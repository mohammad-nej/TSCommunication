//
//  InnerMiddleWareBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//
import TSShared
import Vapor
import OSLog


///Can be used to group routes and add middleware to them.
///
///This type can't be initialized directly, use ``With``  to add middleware(s) to your route(s)
public struct MiddlewareBuilder : Sendable  {
    
     private  nonisolated(unsafe) var  _routes : [any IdentifiableRoute.Type] = []
     private  var lock : NSLock = .init()
     
    init(middleware : (any Middleware) ){
        self.middleWares = [middleware]
    }
    
    init(middlewares : [any Middleware] = []){
        self.middleWares = middlewares
    }
    
     var routes : [any IdentifiableRoute.Type] {
         get{
             lock.lock()
             defer{ lock.unlock() }
             return _routes
         }
         set{
             lock.lock()
             defer { lock.unlock() }
             _routes = newValue
            }
     }
     
     
    var middleWares : [any Middleware] = []
    var innerGroup : [MiddlewareBuilder] = []
    
    func attach(to app: Application,inherited: [any Middleware],previousIds : inout Set<RouteId>, duplicates : inout [RouteId]){
        let combined = inherited + middleWares
        app.group(combined){ vaporGroup in
            for routeType in routes{
                ///Http routes
                if let routeType = routeType as? any AnyHttpRoute.Type{
                    let id = routeType.routeId
                    let (inserted , _ ) = previousIds.insert(id)
                    
                    if !inserted{
                        logger.warning("Route with id: \(id.description) was added more than once. Only the first addition will be used.")
                        duplicates.append(routeType.routeId)
                        continue
                    }
                    
                    vaporGroup.add(routeType)
                }
                //Web sockets
                else if let routeType = routeType as? any ServerWebSocket.Type{
                    let id = routeType.routeId
                    let (inserted , _ ) = previousIds.insert(id)
                    
                    if !inserted{
                        logger.warning("Route with id: \(id.description) was added more than once. Only the first addition will be used.")
                        duplicates.append(routeType.routeId)
                        continue
                    }
                    vaporGroup.add(routeType)
                }else{
                    fatalError("Unsupported route type: \(routeType)")
                }
            }
        }
        for group in innerGroup{
            group.attach(to: app,inherited: combined, previousIds: &previousIds, duplicates: &duplicates)
        }
        
        
    }
 
}
