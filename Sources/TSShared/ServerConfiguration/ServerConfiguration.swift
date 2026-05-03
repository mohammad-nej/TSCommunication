//
//  ServerConfiguration.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation

///Basic information of an HTTP server
public struct ServerConfiguration : Equatable, Sendable, Hashable, Codable {
    
    ///https or http ?
    public enum HttpType : String, Codable, Sendable , Equatable, Hashable {
        case https, http
        
        var webSocket : String {
            switch self {
            case .http:
                "ws"
            case .https:
                "wss"
            }
        }
    }
    
    public let method : HttpType
    public let domain : String
    public let port : Int
   
    ///Creates a server configuration
   public init(method: HttpType, domain: String, port: Int) {
        self.method = method
        self.domain = domain
        self.port = port
    }
    
    ///URL for a http request
    public var url: URL? {
        let string =  "\(method.rawValue)://\(self.domain):\(self.port)"
        return URL(string: string)
    }
    
    ///URL to a server as WebSocket
    public var webSocketURL: URL? {
        let string =  "\(method.webSocket)://\(self.domain):\(self.port)"
        return URL(string: string)
    }
    
    ///address: 127.0.0.1:8080
    public static let local : ServerConfiguration = .init(method:.http,domain: "127.0.0.1", port: 8080)

    public static let test : ServerConfiguration = .init(method: .http, domain: "someWiredDoaim12309.com", port: 8080)
}
