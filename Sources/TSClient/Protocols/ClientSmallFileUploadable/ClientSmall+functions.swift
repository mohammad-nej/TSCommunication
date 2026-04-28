//
//  ClientSmall+functions.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation
import TSShared


public extension ClientSmallFileUploadable{
    
    
    ///Used for sending a file to server using a multipart request
    /// - Parameters:
    ///     - metaData: json that will be send with this file
    ///     - data: the actual data that is being sent
    ///     - filename: name of the file (with extension) that is going to be inject in request
    ///     - parameters: parameters for your request path
    ///     - queryItems: query items for your request
    ///     - config: RequestConf object for this request
    static func upload<T:UpHttpClient>(metaData : InputData? ,
                                       data : Data,
                                       filename : FileName,
                                       parameters : [String] = [],
                                       
                                       queryItems : [URLQueryItem] = [],
                                       config : RequestConfig<T>
    ) async throws -> ServerResponse<Self>{
        
        guard !data.isEmpty else { throw DataError.emptyData }
        
        let url = try Self.path.createURL(parameters: parameters, queryItems: queryItems, server: config.server, mode: config.urlSafetyCheckMode)
        
        //checking the size of data
        if data.count > 25 * 1024 * 1024 { //25mb
            
            logger.warning("You file is too big, consider streaming it instead.")
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
        
        //sending the file
        let (data, response) = try await config.httpClient.upload(for: request, from: body,delegate: config.delegate)
        
        return .init(Self.self, data: data, response: response)
        
    }
    
    @_disfavoredOverload
    ///Used for sending a file to server using a multipart request
    static func upload<T:UpHttpClient>(metaData : InputData? ,
                                       data : Data,filename : FileName,
                                       parameters : [String] = [],
                                       queryItems : [String : String] = [:],
                                       config : RequestConfig<T>
    ) async throws -> ServerResponse<Self> {
        
        let items = queryItems.toQueryItem
        return try await upload(
            metaData: metaData,
            data: data, filename: filename,
            parameters: parameters,
            queryItems: items,
            config: config
        )
        
    }
    
    
}
