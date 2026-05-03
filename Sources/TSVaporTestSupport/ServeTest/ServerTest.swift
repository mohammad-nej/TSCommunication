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
/////Initialize the object
///let tester = ServerTest{ app in
/// RouteInserter(to:app){
///     //insert your routes
/// }
/// //set up db
///}
///
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
 
    
    public init(preparation: @escaping AppPreparationClosure = { _ in },
                cleanups: @escaping AppPreparationClosure = { _ in },
                errorCleanup: @Sendable @escaping (Error) async throws -> () = { _ in } ) {
        self.preparation = preparation
        self.cleanups = cleanups
        self.errorCleanup = errorCleanup
    }
 
    ///Provides an Application instance for you to run your tests with
    ///
    ///The `Application` created by this function will shutdown after it's execution, this means that in a single
    ///test function if you  call this function multiple times, those `Application` objects are different.
    ///
    ///```swift
    ///@Test("My route test function")
    ///func testMyRoute() async throws{
    /// let tester = ServerTest{ app in
    ///     //Setup 
    /// }
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

}
