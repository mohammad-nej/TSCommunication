//
//  WebSocketRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//

import Foundation


///A web socket route
public protocol WebSocketRoute {

    ///Path of the web socket route
    static var path: ServerPath { get }
    
    ///Max frame size of the web socket
    ///
    ///Set it to `nil` to use default size on server
    static var maxFrameSize : Int? { get }
}


public extension WebSocketRoute {
    
    static var maxFrameSize: Int? { nil }
}
