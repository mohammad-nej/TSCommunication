//
//  MockWebSocket.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

import Foundation


///A mock for WebSocket Client
public struct MockWebSocket<S : WebSocketSession > : WebSocketClient{
    
    private let _session: (URL,[String]) -> S
    
    public init(session: @escaping (URL, [String]) -> S) {
        _session = session
    }
    
    public func webSocketTask(with url: URL, protocols: [String]) -> S {
        _session(url, protocols)
    }
}

