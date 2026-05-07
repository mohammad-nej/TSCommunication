//
//  ClientHttp+functions.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation
import TSShared



public extension ClientHttpRoute{
    
    
    ///Sends a  request from client to server and returns the response
    ///
    /// - Parameters:
    ///     - input: the input that you want to send to server
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: server information for this request
    ///     - client: client used to send this request
    ///     - config: configuration for this request
    ///     - modify: lets you modify the request object directly
    static  func send(_ input : InputData, parameters : [String] = [], queryItems : [URLQueryItem] = [],
                      server: ServerConfiguration,
                      client: any UpHttpClient = .shared,
                      config : Configuration = .default,
                      modify : RequestModifier = { _ in }) async throws -> ServerResponse<Self> {
        
        
        //creating url
        let url = try Self.path.createURL(parameters: parameters, queryItems: queryItems ,server: server, mode : config.urlCheckMode)
        
        
        //creating request
        var request = URLRequest(url: url)
        if let timeoutInterval{
            request.timeoutInterval = timeoutInterval
        }
        
        guard contentType != ContentType.multipartFormData else {
            fatalError("If you want to send a multipart request, use ClientSmallFileUploadable protocol instead!")
        }
        
        
        
        request.httpMethod = Self.method.rawValue
        request.setValue(self.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        
        //sending request
        let encodedData = try encoder.encode(input)
        
        
        //checking the size of data
        if encodedData.count > 25 * 1024 * 1024 { //25mb
            let mb = encodedData.count / (1024 * 1024)
            logger.warning("Your payload is too large: \(mb)mb.")
        }
        
        try modify(&request)
        //uploading
        let (data , response) = try await client.upload(for: request, from: encodedData, delegate: config.delegate)
        
        return .init(Self.self, data: data, response: response)
        
        
    }
    
   
    ///Sends a  request from client to server and returns the response
    ///- Parameters:
    ///  - data: the input that you want to send to server
    ///  - parameters: if your server route has a parameter, you should pass them in here
    ///  - queryItems: query items in your request
    ///  - server: server information for this request
    ///  - client: client used to send this request
    ///  - config: configuration for this request
    ///  - modify: lets you modify the request object directly
    @_disfavoredOverload
    static func send(_ data : InputData, parameters : [String] = [], queryItems : [String : String] = [:]       , server: ServerConfiguration,
                     client: any UpHttpClient = .shared,
                     config : Configuration = .default,
                     modify : RequestModifier = { _ in }) async throws -> ServerResponse<Self> {
        let items = queryItems.toQueryItem
        return try await send(
            data,
            parameters: parameters,
            queryItems: items,
            
            server:server,
            client: client,
            config: config,
            modify: modify
        )
        
    }
    
}
