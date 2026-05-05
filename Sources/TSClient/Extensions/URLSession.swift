//
//  URLSession.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation


///Extending URLSession to act as a HttpClient
extension URLSession : HttpClient{}


///Extenind URLSession to act as a WebSocketClient
extension URLSession : WebSocketClient {
    public typealias Session = URLSessionWebSocketTask
}


extension URLSessionWebSocketTask : WebSocketSession {}
