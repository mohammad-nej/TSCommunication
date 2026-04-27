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
///let builder = MiddleWareBuilder(app: application)
///    .build{ group in
///        group.add(middleware:TestMiddleWare2())
///        group.group(TestMiddleWare()) { innerGroup in
///             innerGroup.add(route:route)
///    }
///}
///```
///Once you have created your builders you can add them to your RouteRegistrar
///```swift
///let registrar = RouteRegistrar(routes:[],builders:[builder])
///
///try registrar.register(to:app) //At this point, your routes and middlewares will be attached
///```
public final class MiddlewareBuilder {
    
    public init(){
       
    }

    private var innerBuilder : InnerMiddleWareBuilder? = nil
    

    ///Provides you with a `InnerMiddleWareBuilder` object that lets you append middleware(s) to your route.
    public  func build(_ closure:  (inout InnerMiddleWareBuilder) -> Void){
        var innerBuilder = InnerMiddleWareBuilder(middlewares: [])
        
        closure(&innerBuilder)
        self.innerBuilder = innerBuilder
    }
    
    func attach(to app : Application, previousIds : inout Set<RouteId>, duplicates : inout [RouteId] ){
        if let innerBuilder{
            innerBuilder.attach(to: app, inherited: [], previousIds: &previousIds, duplicates: &duplicates)
        }else{
            logger.warning("Middleware builder is empty, use `run` method first")
        }
            
    }
}
