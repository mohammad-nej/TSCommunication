//
//  GroupResultBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//

import Foundation
import TSShared
import Vapor




@resultBuilder
public struct GroupResultBuilder {
    
    public static func buildBlock(_ components: any ServerGetRouteProtocol.Type...) -> [any ServerGetRouteProtocol.Type] {
        return components
    }
    
    public static func buildFinalResult(_ component: [any ServerGetRouteProtocol.Type]) -> [any Groupable.Type ] {
        var all : [any Groupable.Type] = []
        for component in component {
            let value = component
            all.append(value)
        }
        return all
    }
}


public struct Group {
    let routes: [any Groupable.Type]
    init(@GroupResultBuilder _ closure : () -> [any Groupable.Type]){
        self.routes = closure()
    }
}
