//
//  CollectionBuilder.swift
//  Whisper
//
//  Created by MohammavDev on 4/20/26.
//

import Vapor
import TSShared



///Responsible for adding Middleware(s) to your routes
///
///You can easily add Middleware(s) to your route using this builder:
///```swift
///MiddleWareBuilder(app: application)
///    .run{ group in
///        group.add(middleware:TestMiddleWare2())
///        group.group(TestMiddleWare()) { innerGroup in
///             innerGroup.add(route:route)
///    }
///}
///```
///
/// - important: MiddlewareBuilder will register routes in server, so avoid calling ``AddableRoute/addRoute(to:)`` on these routes again
public struct MiddlewareBuilder {
    
    public init(app : Application ){
        self.application = app
    }


    private let application : Application

    ///Provides you with a `InnerMiddleWareBuilder` object that lets you append middleware(s) to your route.
    public func run(_ closure:  (inout InnerMiddleWareBuilder) -> Void){
        var innerBuilder = InnerMiddleWareBuilder(middlewares: [])
        
        closure(&innerBuilder)
        
        innerBuilder.attach(to: application, inherited: [])
        
    }
}
