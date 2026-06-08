//
//  is.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//


import Foundation
#if os(Linux)
import FoundationNetworking
#endif
///Contains main method of `Foundation/URLSessionWebSocketTask`
///
///This protocol is useful to mock `URLSessionWebSocketTask`
public protocol WebSocketSession {
    func send(_ message : URLSessionWebSocketTask.Message) async throws
    func cancel()
    func resume()
    func receive() async throws -> URLSessionWebSocketTask.Message
}
