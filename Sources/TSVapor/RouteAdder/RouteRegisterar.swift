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




///A type that indicates routes that can be registered to server
///
///All your routes will conform to this type xD
public typealias Registrable = GetHttpRoute & AddingCapableRoute

///Registers all your routes into vapor
///
///You should add all your route and middleware builders to this object. then use ``register(on:Application``.
///```swift
///let registrar = RouteRegistrar(order:.middlewareBuildersFirst)
///
///let allRoutes : [any  Registrable] = [ Myroute(),SecondOne(),...]
///let middlewares : [MiddlewareBuilder] = [ ... ]
///registrar.routes = allRoutes
///registrar.builders = middlewares
///
///try registrar.register(on: application)
///```
///This will register all your routes to vapor server. If you try to add a route more than once, the later ones will be ignored.
///
/// - Warning: You should run ``register(on:Application)`` function **EXACTLY ONCE** when starting up your server. Attempting to run this function more than once will throw error.
public final class RouteRegistrar {

//    nonisolated(unsafe) private static var _byPassForTestingOnly : Bool = false
//    static private let byPassLock = NSLock()
//    
//    
//    
    
//    static var byPassLockForTest : Bool {
//        set {
//            byPassLock.lock()
//            defer { byPassLock.unlock()}
//            
//            _byPassForTestingOnly = newValue
//        }
//        
//        get{
//            byPassLock.lock()
//            defer { byPassLock.unlock()}
//            return _byPassForTestingOnly
//        }
//    }
    
    ///Indicates the order of adding routes to server
    public enum AddingOrder {
        ///Adds non-middleware routes first, then routes in the middleware buidlers
        case routesFirst
        
        ///Adds routes in middleware builders first, then other routes
        case middlewareBuildersFirst
    }
    
//    nonisolated(unsafe) private static var _counter : Int = 0
//    static private let lock = NSLock()
//    
    private var addedRoutes : Set<RouteId> = []
    
//    public enum SafetyMode {
//        ///Safe mode will prevent `registre` function to be called more than once on runtime
//        ///
//        ///Even thought this is a very good feature, this will cause problems when testing your server, cause Swift Testing runs all tests in parallel
//        case safe
//        
//        /// In this mode `registre(to:Application` function can run multiple times.
//        ///
//        /// This mode is should only be used when testing your server. ``ServerTest`` will set this value to `.unsafe`.
//        case unsafe
//    }
    
//    static var counter : Int {
//        get{
//            lock.lock()
//            defer { lock.unlock() }
//            return self._counter
//        }
//        set{
//            lock.lock()
//            defer { lock.unlock() }
//            self._counter = newValue
//        }
//    }
    
    public var duplicates : [RouteId] = []
    public var routes : [any Registrable.Type] = []
    public var builders : [MiddlewareBuilder] = []
    
//    public var mode: SafetyMode = .safe
    
    public let order : AddingOrder
    
    public init(order : AddingOrder = .middlewareBuildersFirst) {
        self.order = order
    }
    
    func addMiddleWares(to app: Application){
        for builder in builders{
            builder.attach(to: app, previousIds: &addedRoutes, duplicates: &self.duplicates)
        }
    }
    
    public func append(_ route : any Registrable.Type){
        self.routes.append(route)
    }
    
    public func append(_ middleware : MiddlewareBuilder){
        self.builders.append(middleware)
    }
    
    func addAllRoutes(to app: Application){
        for routeType in routes{
            let (inserted, _ ) = addedRoutes.insert(routeType.routeId)
            if inserted{
                routeType.addRoute(to:app)
            }else{
                duplicates.append(routeType.routeId)
            }
        }
    }
    
    
    ///Registers routes on vapor server
    ///
    /// - returns: the Id of duplicated routes
    @discardableResult
    public func register(on app: Application) throws -> [RouteId]{
        self.duplicates.removeAll()
        
        guard !self.routes.isEmpty || !self.builders.isEmpty else {
            return []
        }
 
        if order == .middlewareBuildersFirst{
            addMiddleWares(to: app)
            addAllRoutes(to: app)
        }else{
            addAllRoutes(to: app)
            addMiddleWares(to: app)
        }
        return self.duplicates
    }
    
}

