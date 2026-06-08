//
//  ClientBigFile+initializers.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//
import Foundation
import TSShared
#if os(Linux)
import FoundationNetworking
#endif

public extension ClientLargeFileUploadable{
    
    
    ///Streams a large file to server in chunks
    /// - Parameters:
    ///     - fileUrl: url to the file that you want to stream
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: server information for this request
    ///     - client: client used to send this request
    ///     - config: configuration for this request
    ///     - modify: lets you modify the request object directly
    static func upload(fileUrl: URL,
                       parameters : [String] = [] ,
                       queryItems : [URLQueryItem] = [],
                       server: ServerConfiguration,
                       client: any UploadHttpClient = .shared,
                       config : Configuration = .default,
                       modify : RequestModifier = { _ in }
    ) async throws -> ServerResponse<Self> {
        
        let url = try Self.path.createURL(parameters: parameters, queryItems: queryItems, server: server, mode: config.urlCheckMode)
        
        var request = URLRequest(url: url,timeoutInterval: Self.timeoutInterval)
        
        try modify(&request)
        
        let (data , response) = try await client.upload(for: request, fromFile: fileUrl,delegate: config.delegate)
        
        return .init(Self.self, data: data, response: response)
        
    }
    
   
    ///Streams a large file to server in chunks
    ///- Parameters:
    ///   - fileUrl: url to the file that you want to stream
    ///   - parameters: if your server route has a parameter, you should pass them in here
    ///   - queryItems: query items in your request
    ///   - server: server information for this request
    ///   - client: client used to send this request
    ///   - config: configuration for this request
    ///   - modify: lets you modify the request object directly
    @_disfavoredOverload
    static func upload(fileUrl: URL, parameters : [String] = [] ,
                       queryItems : [String:String] = [:],
                       server: ServerConfiguration,
                       client: any UploadHttpClient = .shared,
                       config : Configuration = .default,
                       modify : RequestModifier =  { _ in }
    ) async throws -> ServerResponse<Self> {
        let queryItems = queryItems.toQueryItem
        return try await upload(fileUrl: fileUrl,
                                parameters: parameters,
                                queryItems: queryItems,
                                server: server,
                                client: client,
                                config: config,
                                modify: modify)
    }
    
}
