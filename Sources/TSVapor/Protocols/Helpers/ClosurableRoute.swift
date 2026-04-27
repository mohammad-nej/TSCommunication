//
//  ClosurableRoute.swift
//  Whisper
//
//  Created by MohammavDev on 4/20/26.
//

import Vapor
import TSShared



///Indicates a route that can respond to a request
///
///This protocol is used internally in order to create different kinds of routes, and adding them into Groups in vapor.
///
///You don't need to conform to this protocol 
public protocol VaporRespondable : GetHttpRoute where ClosureResponse : AsyncResponseEncodable {
    associatedtype ClosureResponse : VaporSendableMetatype
    static var closure : @Sendable (Vapor.Request) async throws -> ClosureResponse { get }
    init()
}
