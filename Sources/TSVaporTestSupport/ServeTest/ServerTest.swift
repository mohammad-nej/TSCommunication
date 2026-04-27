//
//  TestDB.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Vapor
import TSVapor


///Wrapper that makes testing your apps easier by doing some setups on your behalf
///
///Use case :
///```swift
///let routes : [any AddableRoute] = [ ... ]
/////Initialize the object
///let tester = ServerTest(routes: routes,builders: [])
///
/////Optionally set closures below
///tester.preparation = { app in
/// //Setup your db , ... in here
/// //This closure runs before adding your routes and before your test begins
///}
///tester.cleanups = { app in
/// //Do cleanups in here
/// //This closure runs when your test finish without throwing
///}
///tester.errorCleanup = { error in
/// //runs in case of any error
///}
///
/////run your tests using `withApp` function
///tester.withApp{ app in
/// //write your tests in here
///}
///```
public final class ServerTest {
   
    ///Closure that runs before each test
    ///
    ///Use this function to setup your database , build routes , ....
    public var preparation : AppPreparationClosure = { _ in}
    
    ///Closure that runs after each test
    ///
    ///Use this function to do clean ups
    public var cleanups : AppPreparationClosure = { _ in }
    
    ///Closure that runs in case of an error
    ///
    ///This closure will run after `Application` shutdown
    public var errorCleanup: @Sendable (Error) async throws -> () = { _ in }
    
    ///Routes are going to be added to `Application`
    ///
    ///These routes will be added **after** `preparation` closure
    public var routes : [any AddingCapableRoute.Type]
    
    ///Middleware builders that are going to be added to `Application`
    ///
    ///These routes will be added **after** `preparation` closure
    public var builders : [MiddlewareBuilder]
    
  
    public var registrationOrder : RouteRegistrar.AddingOrder = .middlewareBuildersFirst
    
    public init(routes : [any AddingCapableRoute.Type], builders : [MiddlewareBuilder] ){
        self.routes = routes
        self.builders = builders
    }
    
    
    public init(routes : [any AddingCapableRoute.Type],
                builders : [MiddlewareBuilder] = [],
                preparation: @escaping AppPreparationClosure = { _ in },
                cleanups: @escaping AppPreparationClosure = { _ in },
                errorCleanup: @Sendable @escaping (Error) async throws -> () = { _ in } ) {
        self.preparation = preparation
        self.cleanups = cleanups
        self.errorCleanup = errorCleanup
        self.routes = routes
        self.builders = builders
    }
 
    ///Provides an Application instance for you to run your tests with
    ///
    ///The `Application` created by this function will shutdown after it's execution, this means that in a single
    ///test function if you  call this function multiple times, those `Application` objects are different.
    ///
    ///This function also will set ``RouteRegistrar`` to **unsafe** mode, this will let are your tests to run in parallel by swift testing,
    ///```swift
    ///@Test("My route test function")
    ///func testMyRoute() async throws{
    /// let tester = ServerTest(routes:[...],builders:[...])
    /// try await tester.withApp{ app in
    ///     //do your test
    /// }
    /// //previous app instance is destroyed by now
    /// try await tester.withApp{ app in
    ///    //fresh instance of Application
    ///    //do tests here
    /// }
    ///}
    public func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await preparation(app)
            try addRoutes(to: app)
            try await test(app)
            try await cleanups(app)
        }
        catch {
            try await errorCleanup(error)
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    func addRoutes(to app: Application) throws {
       let registrar = RouteRegistrar(order: registrationOrder)
        registrar.mode = .unsafe
        registrar.builders = builders
        registrar.routes = self.routes
        
        try registrar.register(on: app)
    }
    
}
