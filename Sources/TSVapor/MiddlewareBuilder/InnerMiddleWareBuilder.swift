//
//  InnerMiddleWareBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//
import TSShared
import Vapor
import OSLog


public typealias Groupable = GetHttpRoute  & VaporRespondable

///Can be used to group routes and add middleware to them.
///
///This type can't be initialized directly, use  ``MiddlewareBuilder``  instead.
public struct InnerMiddleWareBuilder {
    
    
    
    init(middleware : (any Middleware) ){
        self.middleWares = [middleware]
    }
    
    init(middlewares : [any Middleware] = []){
        self.middleWares = middlewares
    }
    
    private(set) var routes : [any Groupable.Type] = []
    private(set) var middleWares : [any Middleware] = []
    private(set) var innerGroup : [InnerMiddleWareBuilder] = []
    
    ///Add a route to this group
    public mutating func add(route : any Groupable.Type){
        routes.append(route)
    }
    
    ///Adds all the routes to the group
    public mutating func add(routes : [any Groupable.Type]){
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
    
    func attach(to app: Application,inherited: [any Middleware],previousIds : inout Set<RouteId>, duplicates : inout [RouteId]){
        let combined = inherited + middleWares
        app.group(combined){ vaporGroup in
            for routeType in routes{
                let route = routeType.init()
                let id = routeType.routeId
                let (inserted , _ ) = previousIds.insert(id)
                
                if !inserted{
                    logger.warning("Route with id: \(id.description) was added more than once. Only the first addition will be used.")
                    duplicates.append(routeType.routeId)
                    continue
                }
                
                vaporGroup.add(route)
            }
        }
        for group in innerGroup{
            group.attach(to: app,inherited: combined, previousIds: &previousIds, duplicates: &duplicates)
        }
        
        
    }
 
}
