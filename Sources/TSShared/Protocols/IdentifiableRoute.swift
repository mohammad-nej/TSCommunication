//
//  RouteIdentifiable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//

import Foundation




public protocol IdentifiableRoute: Hashable {
    static var path : ServerPath { get }
    static var method: HttpMethod { get }
}

public extension IdentifiableRoute {
    
    static var routeId: RouteId {
        .init(path: Self.path, method: Self.method)
    }
    
}

public struct RouteId : Hashable, Equatable, Sendable, CustomStringConvertible {
    public let path: ServerPath
    public let method: HttpMethod
    
    public var description: String {
        "[ \(path.description) : \(method.rawValue) ]"
    }
}

