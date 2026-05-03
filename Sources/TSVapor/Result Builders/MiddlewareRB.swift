//
//  InnerMiddlewareAuto.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor


///Result builder to create a middleware
///
///Use ``With`` instead of directly using this result builder
@resultBuilder
public struct MiddlewareRB{
    

    
    public static func buildBlock(_ components: any IdentifiableRoute.Type...) ->  [MiddlewareBuilder] {
        var middleware = MiddlewareBuilder()
        
        middleware.routes.append(contentsOf: components)
        return [middleware]
    }
    
    public static func buildExpression(_ expression: any IdentifiableRoute.Type...) -> [MiddlewareBuilder] {
        var middleware = MiddlewareBuilder()
        
        middleware.routes.append(contentsOf: expression)
        return [middleware]
    }

    public static func buildBlock(_ components: [MiddlewareBuilder]...) -> [MiddlewareBuilder] {
        return components.flatMap(\.self)
    }
    
    public static func buildExpression(_ expression: Group) ->  [MiddlewareBuilder] {
        var middleware = MiddlewareBuilder()
        
        middleware.routes.append(contentsOf: expression.routes)
        return [middleware]
    }
    public static func buildExpression(_ expression: With) ->  [MiddlewareBuilder] {
        [expression.innerMiddleware]
    }

    public static func buildBlock(_ components: [MiddlewareBuilder]) -> [MiddlewareBuilder] {
        return components
    }
 
    public static func buildFinalResult(_ component: [MiddlewareBuilder]) -> MiddlewareBuilder{
            var builder = MiddlewareBuilder()
            builder.innerGroup.append(contentsOf: component)
            return builder
    }
 
}
