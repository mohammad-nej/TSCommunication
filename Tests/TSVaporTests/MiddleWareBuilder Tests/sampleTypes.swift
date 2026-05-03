//
//  Types.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//

import TSVapor
import TSShared
import Foundation
import Vapor



struct BehindNoMiddleware : ServerGetRouteProtocol {
    static var closure: @Sendable (Vapor.Request) async throws -> Bool{
        return { req in
            let headers = req.headers["Test-Header"]
            return headers.isEmpty
        }
    }
    
    typealias InputData = String
    
    static let path: TSShared.ServerPath = "uploadFile12"
    
    typealias OutputData = Bool
}

struct BehindTestMiddleware : ServerGetRouteProtocol {
    static let path: TSShared.ServerPath = "behindTestMiddleware"
    
    
    typealias OutputData = Bool
    
    static var closure: @Sendable (Vapor.Request) async throws -> Bool{
        return { req in
            let headers = req.headers["Test-Header"]
            
            if let header = headers.first, headers.count == 1 {
                if header == "Middle ware 1 is working" {
                    return true
                }
            }
            return false
        }
    }
}

struct BehindTest2Middleware : ServerGetRouteProtocol {
    static let path: TSShared.ServerPath = "behindTest2Middleware"
    
    
    typealias OutputData = Bool
    
    static var closure: @Sendable (Vapor.Request) async throws -> Bool{
        return { req in
            let headers = req.headers["Test-Header"]
            
            if let header = headers.first, headers.count == 1 {
                if header == "Middle ware 2 is working" {
                    return true
                }
            }
            return false
        }
    }
}

struct WebSocketRoute : ServerWebSocket {
    static var onUpgrade: TSVapor.WebSocketOnUpgrade{
        return { req, ws in
            
        }
    }
    static var path: TSShared.ServerPath { "webSocket" }
}
