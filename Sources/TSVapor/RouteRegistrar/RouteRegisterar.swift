//
//  RouteRegisterar.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//

import Foundation
import TSShared
import Vapor
import Synchronization


///Registers all your routes into vapor
///
///This type can't be initialized directly, use ``RouteInserter`` instead.
public final class RouteRegistrar {

    private var addedRoutes : Set<RouteId> = []
    
    ///Duplicated routes found while adding your routes to server.
    public var duplicates : [RouteId] = []
    
    
    var builders : [MiddlewareBuilder] = []
    
    func addMiddleWares(to app: Application){
        self.addedRoutes = self.alreadyInsertedRoutes(to: app)
        for builder in builders{
            builder.attach(to: app, inherited: [], previousIds: &addedRoutes, duplicates: &self.duplicates)
        }
    }
 
    //Fetch all routes already inserted
    func alreadyInsertedRoutes(to app : Application) -> Set<RouteId>{
        let ids = app.routes.all.map{ route in
            
            let serverPath = route.path.toServerPath()
            let method = route.method.asTSSharedHttpMethod
            
            return RouteId(path: serverPath, method: method)
        }
        if !ids.isEmpty{
            logger.warning("This Application object already has \(ids.count) routes, are you running RouteInserter more than once?")
        }
        
        return Set(ids)
    }
    
    ///Registers routes on vapor server
    ///
    /// - returns: the Id of duplicated routes
    @discardableResult
    public func register(on app: Application) -> [RouteId]{
        self.duplicates.removeAll()
        
        addMiddleWares(to: app)
 
        return self.duplicates
    }
    
}

