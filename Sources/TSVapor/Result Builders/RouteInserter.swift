//
//  GeneralBuilderAuto.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor


///Register all your routes to server
///
///You can easily add your routes using the provided result builder
///```swift
///try RouteInserter{
/// MyRoute()
/// With(middleware: MyMiddleware()){
///     SecondRoute()
/// }
///}
///```
public struct RouteInserter {
   
    
    let registrar : RouteRegistrar
    
    
    @discardableResult
    public init(to app : Application,@RouteBuilderRB _ closure : () -> RouteRegistrar) throws{
        self.registrar =  closure()
        
        try registrar.register(on: app)
    }
}
