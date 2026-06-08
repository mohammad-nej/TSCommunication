//
//  ClientWebSocket+statics.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

import Foundation
import TSShared
#if os(Linux)
import FoundationNetworking
#endif

public extension ClientWebSocketRoute {
    
    ///Creates a web socket to your server
    static func session(with client : any WebSocketClient ,to server : ServerConfiguration, protocols : [String]) throws -> any WebSocketSession{
        let url = try Self.path.webSocketURL(server: server)
        return client.webSocketTask(with: url, protocols: protocols)
    }
    
}

public extension ClientWebSocketRoute {
    static func session(with client : URLSession = .shared , to server: ServerConfiguration , protocols : [String]) throws -> URLSessionWebSocketTask{
        let url = try Self.path.webSocketURL(server: server)
        return client.webSocketTask(with: url, protocols: protocols)
    }
}
