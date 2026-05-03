//
//  GetContacts.swift
//  TSShared
//
//  Created by MohammavDev on 10/18/25.
//

import Vapor
import TSShared

///A route that can send/receive json from/to server
///
///- Note: This protocol should be your go to option for POST,PUSH, .. requests unless you want to either Download/Upload a large file in your request
///
///This protocol will let you add a route to your server by defining the `closure`
///```swift
///extension MyRouteProtocolType : ServerRouteProtocol{
///   static var closure: @Sendable (Vapor.Request) async throws -> MyRouteProtocolType.OutputData {
///     return { req in
///     //do whatever you want in here
///
/// }
///}
///```
public protocol ServerRouteProtocol : HttpRoute, AnyHttpRoute  where InputData : Content , OutputData : Content, ClosureResponse == OutputData{}
