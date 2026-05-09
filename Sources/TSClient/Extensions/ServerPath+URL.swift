//
//  URLCreatable.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/22/26.
//

import Foundation
import TSShared



public extension ServerPath {
    
    ///Creates a url suitable for opening a web socket to this path
    func webSocketURL(server: ServerConfiguration) throws -> URL {
        guard let url = server.webSocketURL else {
            throw URLError(.badURL)
        }
        
        var final = url
        
        final =  final.appending(path: self.pathWithoutFirstSlash)
        return final
    }
    
    ///Creates a url for this route, with parameters and query items
    func createURL(parameters : [String],
                          queryItems : [URLQueryItem] = [],
                          server : ServerConfiguration,
                          mode : URLCreationMode ) throws -> URL {
       
        
        
        guard let server = server.url else {
            throw URLError(.badURL)
        }
        
        var url = try server.appending(path: self.urlValidPath(with: parameters, mode: mode))
        if !queryItems.isEmpty{
            url.append(queryItems: queryItems)
        }
        return url

    }
    
    @_disfavoredOverload
    ///Creates a url for this route, with parameters and query items
    func createURL(parameters : [String],queryItems : [String : String] = [:],server : ServerConfiguration, mode : URLCreationMode) throws -> URL {
        let items = queryItems.toQueryItem
        return try createURL(parameters: parameters, queryItems: items, server: server, mode: mode)
    }
}
