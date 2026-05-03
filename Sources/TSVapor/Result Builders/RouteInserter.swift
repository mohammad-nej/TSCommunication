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
/// MyRoute.self
/// With(middleware: MyMiddleware()){
///     SecondRoute.self
/// }
///}
///```
///This will put your routes behind middleware(s) and register all your routes to vapor upon initialization.
///
///This type will also de-duplicate your routes, check ``duplicates`` .
public struct RouteInserter {
   
    let registrar : RouteRegistrar
    
    ///Duplicate routes that were found during routes registration
    public let duplicates : [RouteId]
    
    @discardableResult
    public init(to app : Application,@RouteBuilderRB _ closure : () -> RouteRegistrar){
        self.registrar =  closure()
        
        let duplicates = registrar.register(on: app)
        self.duplicates = duplicates
    }
}
