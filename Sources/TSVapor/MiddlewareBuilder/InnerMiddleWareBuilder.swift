//
//  InnerMiddleWareBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//
import TSShared
import Vapor


///Can be used to group routes and add middleware to them.
///
///This type can't be initialized directly, use  ``MiddlewareBuilder``  instead.
public struct InnerMiddleWareBuilder {
    
    public typealias Groupable = HttpRoute  & VaporRespondable  & AddableRoute
    
    init(middleware : (any Middleware) ){
        self.middleWares = [middleware]
    }
    
    init(middlewares : [any Middleware] = []){
        self.middleWares = middlewares
    }
    
    private(set) var routes : [(any Groupable)] = []
    private(set) var middleWares : [any Middleware] = []
    private(set) var innerGroup : [InnerMiddleWareBuilder] = []
    
    ///Add a route to this group
    public mutating func add(route : (any Groupable)){
        routes.append(route)
    }
    
    ///Adds all the routes to the group
    public mutating func add(routes : [(any Groupable)]){
        self.routes.append(contentsOf: routes)
    }
    
    ///Add a new to group with a new middleware
    @discardableResult
    public mutating func group(
                appending middleWare : (any Middleware),
                adder : (inout InnerMiddleWareBuilder) -> Void
    ) -> InnerMiddleWareBuilder {
        group(appending:[middleWare],adder: adder)
    }
    
    ///Add a new to group with new middlewares
    @discardableResult
    public mutating func group(
                appending middleWares : [any Middleware] = [],
                adder : (inout InnerMiddleWareBuilder) -> Void
    ) -> InnerMiddleWareBuilder {
        
        var newGroup = InnerMiddleWareBuilder(middlewares:middleWares)
        adder(&newGroup)
        
        
        self.innerGroup.append(newGroup)
        
        return newGroup
    }
    
    ///Add a middleware to current group
    public mutating func add(middleware : any Middleware){
        self.middleWares.append(middleware)
    }
    
    ///Add elements to this group middlewares
    public mutating func add(middlewares : [any Middleware]){
        self.middleWares.append(contentsOf: middlewares)
    }
    
    func attach(to app: Application,inherited: [any Middleware]){
        let combined = inherited + middleWares
        app.group(combined){ vaporGroup in
            for route in routes{
                vaporGroup.add(route)
            }
        }
        for group in innerGroup{
            group.attach(to: app,inherited: combined)
        }
        
        
    }
 
}
