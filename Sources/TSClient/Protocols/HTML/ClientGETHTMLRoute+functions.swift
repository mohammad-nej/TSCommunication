//
//  ClientGETHTMLRoute+functions.swift
//  TSCommunication
//
//  Created by MohammavDev on 6/7/26.
//



import  TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif


public extension ClientGetHTMLRoute {
    ///Get  HTML  from server
    /// - Parameters:
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: server information for this request
    ///     - client: client used to send this request
    ///     - config: configuration for this request
    ///     - modify: lets you modify the request object directly
    static func get(parameters : [String],queryItems : [URLQueryItem] = [],server : ServerConfiguration , client : any GETHttpClient = .shared, config : Configuration = .default,modify : RequestModifier = { _ in }) async throws -> ServerResponse<Self>{
        guard Self.method == .GET else { fatalError("HTTPMethod is not .GET") }
        
        let url = try Self.path.createURL(parameters: parameters,
                                          queryItems: queryItems,
                                          server: server,
                                          mode: config.urlCheckMode)
        
        var request = URLRequest(url: url)
        request.httpMethod = Self.method.rawValue
        if let timeoutInterval{
            request.timeoutInterval = timeoutInterval
        }
        try modify(&request)
        let (data, response) = try await client.data(for: request, delegate: config.delegate)
//        let decoded = try Self.decoder.decodeIfNeeded(OutputData.self, from: data)
        return  .init(Self.self,data: data, response: response)
        
    }
    
    
    ///Get HTML from server
    /// - Parameters:
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: server information for this request
    ///     - client: client used to send this request
    ///     - config: configuration for this request
    ///     - modify: lets you modify the request object directly
    @_disfavoredOverload
    static func get(parameters : [String],queryItems : [String : String],server : ServerConfiguration , client : any GETHttpClient = .shared, config : Configuration = .default,modify : RequestModifier = { _ in } ) async throws -> ServerResponse<Self>{
        
        let items = queryItems.toQueryItem
        return try await get(parameters: parameters,
                             queryItems: items,
                             server: server,
                             client:client,
                             config:config,
                             modify: modify
        )
        
    }
    
}
