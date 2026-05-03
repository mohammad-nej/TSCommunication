//
//  ClientBigFile+initializers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//
import Foundation
import TSShared

public extension ClientLargeFileUploadable{
    
    
    ///Streams a large file to server in chunks
    /// - Parameters:
    ///     - fileUrl: url to the file that you want to stream
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - config: RequestConf object for this request
    static func upload<T:UploadHttpClient>(fileUrl: URL,
                       parameters : [String] = [] ,
                       queryItems : [URLQueryItem] = [],
                       config: RequestConfig<T>
    ) async throws -> ServerResponse<Self> {
        
        let url = try Self.path.createURL(parameters: parameters, queryItems: queryItems, server: config.server, mode: config.urlSafetyCheckMode)
        
        let request = URLRequest(url: url,timeoutInterval: Self.timeoutInterval)
        
        let (data , response) = try await config.httpClient.upload(for: request, fromFile: fileUrl,delegate: config.delegate)
   
        return .init(Self.self, data: data, response: response)
     
    }
    
    @_disfavoredOverload
    ///Streams a large file to server in chunks
    static func upload<T:UploadHttpClient>(fileUrl: URL, parameters : [String] = [] ,
                       queryItems : [String:String] = [:],
                       config: RequestConfig<T>
    ) async throws -> ServerResponse<Self> {
        let queryItems = queryItems.toQueryItem
        return try await upload(fileUrl: fileUrl,
                                parameters: parameters,
                                queryItems: queryItems,
                                config: config)
    }
    
}
