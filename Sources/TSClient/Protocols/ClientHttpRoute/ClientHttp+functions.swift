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
    static  func send<T:UpHttpClient>(_ input : InputData, parameters : [String] = [], queryItems : [URLQueryItem] = [] ,config : RequestConfig<T>) async throws -> (OutputData,URLResponse) {
        
        
        //creating url
        let url = try Self.path.createURL(parameters: parameters, queryItems: queryItems ,server: config.server, mode : config.urlSafetyCheckMode)
        
        
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
        
        var encodedData = try encoder.encodeIfNeeded(input)
       
        
        //checking the size of data
        if encodedData.count > 25 * 1024 * 1024 { //25mb
            let mb = encodedData.count / (1024 * 1024)
            logger.warning("Your payload is too large: \(mb)mb.")
        }
        
        //uploading
        let (data , response) = try await config.httpClient.upload(for: request, from: encodedData, delegate: config.delegate)
    
    
        
        let decoded = try Self.decoder.decodeIfNeeded(OutputData.self, from: data)
        return (decoded,response)
        
        
    }
    
    @_disfavoredOverload
    ///Sends a  request from client to server and returns the response
    ///- Parameters:
    ///  - data: the input that you want to send to server
    ///  - parameters: if your server route has a parameter, you should pass them in here
    ///  - queryItems: query items in your request
    ///  - server: base address of your server
    ///  - mode: the mode that is used to validate your url
    static func send<T:UpHttpClient>(_ data : InputData, parameters : [String] = [], queryItems : [String : String] = [:] , config : RequestConfig<T>) async throws -> (OutputData,URLResponse) {
        let items = queryItems.toQueryItem
        return try await send(
            data,
            parameters: parameters,
            queryItems: items,
            config: config
        )
        
    }
    
}
