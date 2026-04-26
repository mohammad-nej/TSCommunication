//
//  GetRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import Vapor
import TSShared


///This can be used to create GET request
///
///This protocol just sets your InputData to `NoData`, since GET request can't have any content
public protocol ServerGetRouteProtocol : GetHttpRoute,VaporRespondable, AddableRoute where ClosureResponse == OutputData{
}

public extension ServerGetRouteProtocol {
    static var method: HttpMethod { .get }
    
    
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
                       body: .collect,
                       use: Self.closure)
    }

}
