//
//  GroupResultBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//

import Foundation
import TSShared
import Vapor



///result builder to create a heterogenous array of routes
///
///Use ``Group`` instead of directly using this result builder
@resultBuilder
public struct GroupResultBuilder {
    
    public static func buildBlock(_ components: any IdentifiableRoute.Type...) -> [any IdentifiableRoute.Type] {
        return components
    }
    
    public static func buildBlock(_ components: [any IdentifiableRoute.Type]) -> [any IdentifiableRoute.Type] {
        components
    }

    public static func buildExpression(_ expression: any IdentifiableRoute.Type...) -> [any IdentifiableRoute.Type] {
        expression
    }
    public static func buildBlock(_ components: [any IdentifiableRoute.Type]...) -> [any IdentifiableRoute.Type] {
        components.flatMap(\.self)
    }
    public static func buildExpression(_ expression: Group) -> [any IdentifiableRoute.Type] {
        expression.routes
    }
}



