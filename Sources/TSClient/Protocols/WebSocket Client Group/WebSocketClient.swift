//
//  WebSocketClient.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

import Foundation





///any client that can create a web socket
///
///This can be used to mock a web socket client
///
/// - Note: `URLSession` is already extended to be a ``WebSocketClient``
public protocol WebSocketClient {
    associatedtype Session : WebSocketSession
    func webSocketTask(with url: URL, protocols: [String]) -> Session
}


public extension WebSocketClient where Self == URLSession{
    ///`URLSession.shared` as client
    static var shared : Self {
        return .shared
    }
}



