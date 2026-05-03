//
//  ClientWebSocket+statics.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

import Foundation
import TSShared

public extension ClientWebSocketRoute {
    
    ///Creates a web socket to your server
    static func session<T:WebSocketClient>(with client : T = URLSession.shared,to server : ServerConfiguration, protocols : [String]) throws -> T.Session{
        let url = try Self.path.webSocketURL(server: server)
        return client.webSocketTask(with: url, protocols: protocols)
    }
    
}
