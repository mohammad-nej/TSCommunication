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
    public static func buildBlock(_ components: [any InnerMiddewareContainer]) -> [InnerMiddleWareBuilder] {
        return components.map { $0.innerMiddleware }
    }
    
    public static func buildFinalResult(_ components: [InnerMiddleWareBuilder]) -> RouteRegistrar {
        var finalBuilder = MiddlewareBuilder()
        finalBuilder.innerBuilder = components
        
        let registrar = RouteRegistrar()
        registrar.builders = [finalBuilder]
        return registrar
    }
 
}
