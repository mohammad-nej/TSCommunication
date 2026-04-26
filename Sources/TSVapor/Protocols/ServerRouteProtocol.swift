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
///once you have defined your closure you can simply add it your vapor project using `addRoute` function
///```swift
/////in your vapor routes file
///let someRoute = MyRouteProtocolType()
///try someRoute.addRoute(to:app)
///```
///if you have many routes ( which you should have) you can put them all in a single array like so:
///```swift
/////in your vapor routes file
///let routes : [any SeverRouteProtocol] = [
/// MyRouteProtocolType(),
/// //...
///]
///try routes.forEach{ try $0.addRoute(to:app) }
///```
public protocol ServerRouteProtocol : HttpRoute,VaporRespondable, FileTransferMethodable ,AddableRoute where InputData : Content , OutputData : Content
                                                                                                                ,ClosureResponse == OutputData
{
    
}

public extension ServerRouteProtocol  {
    
    ///Registers this route in your vapor server.
    ///
    ///This function should be called once per route in your entire application.
    ///
    /// - important: If you are using `MiddlewareBuilder` to add middleware(s) to your route, you shouldn't't
    /// call this function yourself, cause middleware builder `attach(to:Application)` function will call this function internally
    func addRoute(to application : Application) throws{
      
        let components = Self.path.vaporComponents
        let method = Self.method
        
        application.on(method.asVaporHTTPMethod,
                       components,
                       body: Self.transferMethod.toVaporSteamStrategy,
                       use: Self.closure)
    }
    
    
}




