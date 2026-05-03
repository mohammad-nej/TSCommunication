//
//  GeneralBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor


///Result builder for creating your routes on server
///
///Use ``RouteInserter`` to register your routes to server instead
@resultBuilder
public struct RouteBuilderRB{
    public static func buildBlock(_ components: any IdentifiableRoute.Type...) -> [MiddlewareBuilder] {
        var middleware = MiddlewareBuilder()
        
        middleware.routes.append(contentsOf: components)
        return [middleware]

    }
    
    public static func buildExpression(_ expression: any IdentifiableRoute.Type) -> [MiddlewareBuilder] {
        var middleware = MiddlewareBuilder()
        
        middleware.routes.append(expression)
        return [middleware]

    }

    public static func buildExpression(_ expression: Group) -> [MiddlewareBuilder] {
        var middleware = MiddlewareBuilder()
        middleware.routes.append(contentsOf: expression.routes)
        
        return [middleware]
    }
    public static func buildBlock(_ components: [MiddlewareBuilder]...) -> [MiddlewareBuilder] {
        return components.flatMap(\.self)
    }
    public static func buildExpression(_ expression: With) -> [MiddlewareBuilder] {
        [expression.innerMiddleware]
    }

    public static func buildExpression(_ expression: MiddlewareBuilder) -> [MiddlewareBuilder] {
        [expression]
    }
    
    public static func buildArray(_ components: [[MiddlewareBuilder]]) -> [MiddlewareBuilder] {
        return components.flatMap(\.self)
    }
    public static func buildFinalResult(_ components: [MiddlewareBuilder]) -> RouteRegistrar {
        
        let registrar = RouteRegistrar()
        registrar.builders = components
        return registrar
    }
 
}
