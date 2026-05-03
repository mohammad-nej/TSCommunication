//
//  ServerWebSocket.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//

import Foundation
import TSShared
import Vapor


public typealias WebSocketOnUpgrade = @Sendable (Request,WebSocket) async  -> Void
public typealias WebSocketShouldUpgrade = @Sendable (Request) async throws -> HTTPHeaders?

/// protocol for routes that use WebSocket instead of HTTP
///
/// By conforming to this you should provide ``onUpgrade`` closure
/// ```swift
/// extension MyWebSocketRoute : ServerWebSocket{
///     static var onUpgrade : WebSocketOnUpgrade {
///         return { req,ws in
///             //...
///         }
///     }
///}
///```
public protocol ServerWebSocket : WebSocketRoute, IdentifiableRoute {
    static var onUpgrade :  WebSocketOnUpgrade{ get }
    static var shouldUpgrade : WebSocketShouldUpgrade? { get }
}




