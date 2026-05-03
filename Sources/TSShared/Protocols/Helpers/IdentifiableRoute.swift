//
//  RouteIdentifiable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//

import Foundation



///Creates an ID for a route
///
///All routes conforms to this protocol.
public protocol IdentifiableRoute: Hashable {
    static var routeId : RouteId { get }
}

public extension IdentifiableRoute where Self : GetHttpRoute {
    
    static var routeId: RouteId {
        .init(path: Self.path, method: Self.method)
    }
    
}



///Acts as in ID for a route
public struct RouteId : Hashable, Equatable, Sendable, CustomStringConvertible {
    public let path: ServerPath
    public let method: String
    
    public init(webSocket path : ServerPath){
        self.path = path
        self.method = "WebSocket"
    }
    public init(path: ServerPath, method: HttpMethod) {
        self.path = path
        self.method = method.rawValue
    }
    public var description: String {
        "[ \(path.description) : \(method) ]"
    }
}

