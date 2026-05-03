//
//  ServerWeb+defaults.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//


import Foundation
import TSShared
import Vapor

public extension ServerWebSocket {
    
    static var shouldUpgrade :  WebSocketShouldUpgrade? {
        return nil
    }
    
    ///Id of this route
    static var routeId: RouteId {
        .init(webSocket: Self.path)
    }
}
