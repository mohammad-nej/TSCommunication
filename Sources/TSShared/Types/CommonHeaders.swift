//
//  CommonHeaders.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/8/26.
//

import Foundation
#if os(Linux)
import FoundationNetworking
#endif


///Common HTTP headers used in requests
///
///Common headers used in HTTP request are already implemented as static variables
///```swift
///let authHeader = CommonHeader.authorization
///```
public struct CommonHeader : Sendable , Codable , Equatable , Hashable{
    public let name : String
    public init(name: String) {
        self.name = name
    }
}

public extension CommonHeader {
    
    static let authorization = Self(name: "Authorization")
    
    static let contentLength = Self(name: "Content-Length")
    
    static let contentType = Self(name: "Content-Type")
    
    static let accept = Self(name: "Accept")
    
    static let userAgent = Self(name: "User-Agent")
    
    static let acceptEncoding = Self(name: "Accept-Encoding")
    
    static let cookie = Self(name: "Cookie")
    
    static let host = Self(name: "Host")
    
    static let cacheControl = Self(name: "Cache-Control")
    
    static let origin = Self(name: "Origin")
    
    static let referer = Self(name: "Referer")
    
    static let idempotencyKey = Self(name: "Idempotency-Key")
    
    static let ifNoneMatch = Self(name: "If-None-Match")
    
    ///X-API-Key
    static let requestID = Self(name: "X-Request-ID")
    
    ///X-API-Key
    static let apiKey = Self(name: "X-API-Key")
    
    ///X-App-Version
    static let appVersion = Self(name: "X-App-Version")
    
    ///X-Platform
    static let platform = Self(name: "X-Platform")
}

extension CommonHeader : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.name = value
    }
}



///Common headers used in an HTTP request with its value
///
///Functions to create common headers used in HTTP request are already provided.
///
///Both `URLRequest` and `URLResponse` are extended to make fetching/inserting headers easier
///```swift
/////in your request
///request.appending(.accept("application/json, text/plain"))
///```
public struct CommonHeaderItem : Sendable , Codable , Equatable , Hashable{
   
    ///Header itself
    public let header : CommonHeader
    
    ///Value of the header
    public let value : String
    
    ///shortcut for header.name
    public var name : String { header.name }
    
    ///Creates an HTTP header for you
    public init(header: CommonHeader, value : String) {
        self.header = header
        self.value = value
    }
}



///Bunch of common headers
public extension CommonHeaderItem {
    
    ///Creates an Authorization header
    static func auth(_ value : String) -> CommonHeaderItem {
        .init(header: .authorization, value: value)
    }
    
    ///Creates a Content-Length header
    static func contentLength(_ value : Int) -> CommonHeaderItem {
        .init(header: .contentLength, value: "\(value)")
    }
    
    ///Creates an Accept header
    static func accept(_ value : String) -> CommonHeaderItem {
        .init(header: .accept, value: value)
    }
    
    ///Creates a Bearer Authorization header
     static func bearerAuth(_ token : String) -> CommonHeaderItem {
         .init(header: .authorization, value: "Bearer \(token)")
     }
     
    
    ///Creates an application/json Accept header
    static func acceptJSON() -> CommonHeaderItem {
        .init(header: .accept, value: "application/json")
    }
    
    ///Creates a User-Agent header
    static func userAgent(_ value : String) -> CommonHeaderItem {
        .init(header: .userAgent, value: value)
    }
    
   
    ///Creates an Accept-Encoding header
    static func acceptEncoding(_ value : String) -> CommonHeaderItem {
        .init(
            header: .acceptEncoding,
            value: value
        )
    }
    
    ///Creates a Cookie header
    static func cookie(_ value : String) -> CommonHeaderItem {
        .init(header: .cookie, value: value)
    }
    
    ///Creates a Host header
    static func host(_ value : String) -> CommonHeaderItem {
        .init(header: .host, value: value)
    }
    
    ///Creates a Cache-Control header
    static func cacheControl(_ value : String) -> CommonHeaderItem {
        .init(header: .cacheControl, value: value)
    }
    
    ///Creates an Origin header
    static func origin(_ value : String) -> CommonHeaderItem {
        .init(header: .origin, value: value)
    }
    
    ///Creates a Referer header
    static func referer(_ value : String) -> CommonHeaderItem {
        .init(header: .referer, value: value)
    }
    
    ///Creates an Idempotency-Key header
    static func idempotencyKey(_ value : String) -> CommonHeaderItem {
        .init(header: .idempotencyKey, value: value)
    }
    
    ///Creates an ETag validation header
    static func ifNoneMatch(_ value : String) -> CommonHeaderItem {
        .init(header: .ifNoneMatch, value: value)
    }
    
    ///Creates an X-Request-ID header
    static func requestID(_ value : String) -> CommonHeaderItem {
        .init(header: .requestID, value: value)
    }
    
    ///Creates an X-API-Key header
    static func apiKey(_ value : String) -> CommonHeaderItem {
        .init(header: .apiKey, value: value)
    }
    
    ///Creates an X-App-Version header
    static func appVersion(_ value : String) -> CommonHeaderItem {
        .init(header: .appVersion, value: value)
    }
    
    ///Creates an X-Platform header
    static func platform(_ value : String) -> CommonHeaderItem {
        .init(header: .platform, value: value)
    }
}
