//
//  InnerMiddlewareAuto.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor


///Result builder to create a InnerMiddlewareBuilder
@resultBuilder
public struct InnerMiddlewareRB{
    
    public static func buildBlock(_ components: any BuildableBlock...) -> [any BuildableBlock] {
        return components
    }
    
 
    
    public static func buildBlock(_ components : [any BuildableBlock]...) -> [any BuildableBlock] {
        return components.flatMap{$0}
    }

    public static func buildArray(_ components: [[any BuildableBlock]]) -> [any BuildableBlock] {
        components.flatMap { 
            $0
        }
    }
    
    public static func buildExpression(_ expression: any BuildableBlock) -> [any BuildableBlock] {
        [expression]
    }
    
    public static func buildExpression(_ expression: Group) -> [any BuildableBlock] {
        expression.routes.map{ $0.init() as any BuildableBlock}
    }
    
    public static func buildFinalResult(_ components: [any BuildableBlock]) -> InnerMiddleWareBuilder {
        
        var builder = InnerMiddleWareBuilder()
        
        var inners : [InnerMiddleWareBuilder] = []
        for component in components {
            if let comp = component as? With{
                inners.append(comp.innerMiddleware)
            }
            else{
                builder.routes.append(contentsOf:component.routes)
            }
        }
        builder.innerGroup = inners
        return builder
    }
}
