//
//  ServerConfiguration.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation

///Basic information of an HTTP server
public struct ServerConfiguration : Equatable, Sendable, Hashable, Codable {
    
    public enum HttpType : String, Codable, Sendable , Equatable, Hashable {
        case https, http
    }
    
    public let method : HttpType
    public let domain : String
    public let port : Int
   
   public init(method: HttpType, domain: String, port: Int) {
        self.method = method
        self.domain = domain
        self.port = port
    }
    
    public var url: URL? {
        let string =  "\(method.rawValue)://\(self.domain):\(self.port)"
        return URL(string: string)
    }
    
    ///address: 127.0.0.1:8080
    public static let local : ServerConfiguration = .init(method:.http,domain: "127.0.0.1", port: 8080)

    public static let test : ServerConfiguration = .init(method: .http, domain: "myTestDomain.com", port: 8080)
}
