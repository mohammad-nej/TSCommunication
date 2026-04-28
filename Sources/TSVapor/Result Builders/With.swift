//
//  InnerMiddleWareFinal.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor



    
///Adds a middle ware to any route inside it
public struct With : InnerMiddewareContainer, BuildableBlock {
    public var routes: [any Groupable.Type] {
        innerMiddleware.routes
    }
    
    public let innerMiddleware : InnerMiddleWareBuilder
    
    public init(middlewares : [ Vapor.Middleware], @InnerMiddlewareRB _ closure : () -> InnerMiddleWareBuilder){
        var builder = closure()
        builder.middleWares = middlewares
        self.innerMiddleware = builder
    }
    
    public init(middleware : Vapor.Middleware, @InnerMiddlewareRB _ closure : () -> InnerMiddleWareBuilder){
        var builder = closure()
        builder.middleWares = [middleware]
        self.innerMiddleware = builder
    }
    
}

