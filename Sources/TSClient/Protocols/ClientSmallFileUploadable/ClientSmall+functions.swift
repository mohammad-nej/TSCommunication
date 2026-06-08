//
//  ClientSmall+functions.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation
import TSShared
#if os(Linux)
import FoundationNetworking
#endif

public extension ClientSmallFileUploadable{
    
    
    ///Used for sending a file to server using a multipart request
    /// - Parameters:
    ///     - metaData: json that will be send with this file
    ///     - data: the actual data that is being sent
    ///     - filename: name of the file (with extension) that is going to be inject in request
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: server information for this request
    ///     - client: client used to send this request
    ///     - config: configuration for this request
    ///     - modify: lets you modify the request object directly
    static func upload(metaData : InputData? ,
    data : Data,
    filename : FileName,
    parameters : [String] = [],
    
    queryItems : [URLQueryItem] = [],
    server: ServerConfiguration,
    client: any UpHttpClient = .shared,
    config : Configuration = .default,
    modify : RequestModifier = { _ in }
    ) async throws -> ServerResponse<Self>{
        
        guard !data.isEmpty else { throw DataError.emptyData }
        
        let url = try Self.path.createURL(parameters: parameters, queryItems: queryItems, server: server, mode: config.urlCheckMode)
        
        //checking the size of data
        if data.count > 25 * 1024 * 1024 { //25mb
            #if canImport(OSLog)
            logger.warning("You file is too big, consider streaming it instead.")
            #else
            print("You file is too big, consider streaming it instead.")
            #endif
        }
        
        var request = URLRequest(url: url, timeoutInterval: Self.timeoutInterval)
        
        request.httpMethod = Self.method.rawValue
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        let dtoData = try encoder.encode(metaData)
        
        
        //dto
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"metaData\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append(dtoData)
        body.append("\r\n".data(using: .utf8)!)
        
        //file
        
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename.fullname)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(Self.contentType.rawValue)\r\n".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        
        //end of body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        try modify(&request)
        //sending the file
        let (data, response) = try await client.upload(for: request, from: body,delegate: config.delegate)
        
        return .init(Self.self, data: data, response: response)
        
    }
    
    
    ///Used for sending a file to server using a multipart request
    ///   - Parameters:
    ///     - metaData: json that will be send with this file
    ///     - data: the actual data that is being sent
    ///     - filename: name of the file (with extension) that is going to be inject in request
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: server information for this request
    ///     - client: client used to send this request
    ///     - config: configuration for this request
    ///     - modify: lets you modify the request object directly
    @_disfavoredOverload
    static func upload(metaData : InputData? ,
                       data : Data,filename : FileName,
                       parameters : [String] = [],
                       queryItems : [String : String] = [:],
                       server: ServerConfiguration,
                       client: any UpHttpClient = .shared,
                       config : Configuration = .default,
                       modify : RequestModifier = { _ in }
    ) async throws -> ServerResponse<Self> {
        
        let items = queryItems.toQueryItem
        return try await upload(
            metaData: metaData,
            data: data, filename: filename,
            parameters: parameters,
            queryItems: items,
            server: server,
            client: client,
            config: config,
            modify: modify
        )
        
    }
    
    
}
