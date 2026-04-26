//
//  ClientGet+functions.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation
import TSShared

public extension ClientGetRouteProtocol{
    ///Get some information from server
    /// - Parameters:
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: base address of your server
    ///     - mode: the mode that is used to validate your url
    static func get<T:GETHttpClient>(parameters : [String],queryItems : [URLQueryItem] = [], config : RequestConfig<T> ) async throws -> (OutputData,URLResponse){
        guard Self.method == .get else { fatalError("HTTPMethod is not .get") }
        
        let url = try Self.path.createURL(parameters: parameters,
                                          queryItems: queryItems,
                                          server: config.server,
                                          mode: config.urlSafetyCheckMode)
        
        var request = URLRequest(url: url)
        request.httpMethod = Self.method.rawValue
        if let timeoutInterval{
            request.timeoutInterval = timeoutInterval
        }
        
        let (data, response) = try await config.httpClient.data(for: request, delegate: config.delegate)
        let decoded = try Self.decoder.decodeIfNeeded(OutputData.self, from: data)
        return (decoded,response)
        
    }
    
    @_disfavoredOverload
    ///Get some information from server
    /// - Parameters:
    ///     - parameters: if your server route has a parameter, you should pass them in here
    ///     - queryItems: query items in your request
    ///     - server: base address of your server
    ///     - mode: the mode that is used to validate your url
    static func get<T:GETHttpClient>(parameters : [String],queryItems : [String : String],config : RequestConfig<T> ) async throws -> (OutputData,URLResponse){
        
        let items = queryItems.toQueryItem
        return try await get(parameters: parameters,
                             queryItems: items,
                             config: config)
        
    }
}
