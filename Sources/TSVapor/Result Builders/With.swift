//
//  InnerMiddleWareFinal.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor



    
///Adds middleware(s) to any route inside it
///
///You can put your routes behind middleware(s) using this type.
///```swift
///With(middleware:MyMiddleware()){
/// FirstRoute.self
/// SecondRoute.self
/// With(middleware:MyMiddleware2()){
///   //Both MyMiddleware() and MyMiddleware2() will be applied to this route
///     ThirdRoute.self
/// }
///}
///```
public struct With : Sendable {

    public let innerMiddleware : MiddlewareBuilder
    
    public init(middlewares : [ Vapor.Middleware], @MiddlewareRB _ closure : () -> MiddlewareBuilder){
        var builder = closure()
        builder.middleWares = middlewares
        self.innerMiddleware = builder
    }
    
    public init(middleware : Vapor.Middleware, @MiddlewareRB _ closure : () -> MiddlewareBuilder){
        var builder = closure()
        builder.middleWares = [middleware]
        self.innerMiddleware = builder
    }
    
}

