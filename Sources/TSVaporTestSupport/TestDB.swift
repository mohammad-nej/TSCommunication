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
///var tester = ServerTest(routes: routes)
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
public struct ServerTest {
   
    ///Closure that runs before each test
    ///
    ///Use this function to setup your database , build routes , ....
    public var preparation : @Sendable (Application) async throws -> () = { _ in}
    
    ///Closure that runs after each test
    ///
    ///Use this function to do clean ups
    public var cleanups : @Sendable (Application) async throws -> () = { _ in }
    
    ///Closure that runs in case of an error
    ///
    ///This closure will run after `Application` shutdown
    public var errorCleanup: @Sendable (Error) async throws -> () = { _ in }
    
    ///Routes are going to be added to `Application`
    ///
    ///These routes will be added **after** `preparation` closure
    public var routes : [any AddableRoute] = []
    
    public init(routes : [any AddableRoute]){
        self.routes = routes
    }
    
    @_disfavoredOverload
    public init(routes : [any AddableRoute],
                preparation: @Sendable @escaping (Application) async throws -> (),
                cleanups: @Sendable @escaping (Application) async throws -> (),
                errorCleanup: @Sendable @escaping (Error) async throws -> ()) {
        self.preparation = preparation
        self.cleanups = cleanups
        self.errorCleanup = errorCleanup
        self.routes = routes
    }
    
    ///Runs test in an onMemory sqlite database for testing purposes
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
        for route in routes {
            try  route.addRoute(to: app)
        }
    }
    
}
