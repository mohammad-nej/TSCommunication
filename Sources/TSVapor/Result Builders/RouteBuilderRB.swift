//
//  GeneralBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor

@resultBuilder
public struct RouteBuilderRB{
    public static func buildBlock(_ components: any InnerMiddewareContainer...) -> [InnerMiddleWareBuilder] {
        return components.map { $0.innerMiddleware }
    }
    public static func buildBlock(_ components: [any InnerMiddewareContainer]...) -> [InnerMiddleWareBuilder] {
        var inners = [InnerMiddleWareBuilder]()
        for comp in components {
            inners.append(contentsOf: comp.map(\.innerMiddleware))
        }
        return inners
    }

    public static func buildExpression(_ expression: Group) -> [InnerMiddleWareBuilder] {
        var middleware = InnerMiddleWareBuilder()
        middleware.routes.append(contentsOf: expression.routes)
        
        return [middleware]
    }
    
    public static func buildExpression(_ expression: any InnerMiddewareContainer) -> [InnerMiddleWareBuilder] {
        return [expression.innerMiddleware]
    }
    public static func buildExpression(_ expression: InnerMiddleWareBuilder) -> [InnerMiddleWareBuilder] {
        [expression]
    }
    
    public static func buildArray(_ components: [[InnerMiddleWareBuilder]]) -> [InnerMiddleWareBuilder] {
        return components.flatMap(\.self)
    }
    public static func buildFinalResult(_ components: [InnerMiddleWareBuilder]) -> RouteRegistrar {
        var finalBuilder = MiddlewareBuilder()
        finalBuilder.innerBuilder = components
        
        let registrar = RouteRegistrar()
        registrar.builders = [finalBuilder]
        return registrar
    }
 
}
