//
//  GetContacts.swift
//  TSShared
//
//  Created by MohammavDev on 10/18/25.
//

import Vapor
import TSShared

///By extending your RouteProtocol to this protocol, you will be able to create your route in server using the provided closure.
///
///- Note: This protocol should be your go to option unless you want to either Download/Upload a large file in your request ( in that case you should conform to
///`DownloadableServerRouteProtocol`/`UploadableServerRouteProtocol` instead.
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
public protocol ServerRouteProtocol : ServerGetRouteProtocol,HttpRoute  where InputData : Content , OutputData : Content{}
