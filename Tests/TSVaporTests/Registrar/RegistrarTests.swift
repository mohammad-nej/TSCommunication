//
//  RegistrarTests.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//

import TSShared
import Foundation
import Vapor
import Testing
@testable import TSVapor
import TSVaporTestSupport


@Suite("Registrar related")
struct RegistrarTests {
    
    
    
    @Test("Test RouteRegistrar")
    func registrar() async throws {
    
            try await withApp { app in
                let routes = Group{
                    BehindBothMiddlewares.self
                    SecondTest.self
                    ThirdTest.self
                }
                
                let duplicates =  RouteInserter(to: app) {
                    routes
                }.duplicates
                
                #expect(duplicates.isEmpty)
            }
          
            try await withApp { app in
              
                
                let duplicates =  RouteInserter(to: app) {
                    SecondTest.self
                    SecondTest.self
                }.duplicates
                
                #expect(duplicates.count == 1)
                #expect(duplicates[0] == SecondTest.routeId)
            }
        
            try await withApp { app in

                let duplicates =  RouteInserter(to:app){
                    ThirdTestSimillar.self
                    ThirdTestSimillar.self
                    SecondTest.self
                    ThirdTest.self
                }.duplicates
                
                #expect(duplicates.count == 2)
                #expect(duplicates[0] == ThirdTestSimillar.routeId)
                #expect(duplicates[1] == ThirdTestSimillar.routeId)
            }
 
    }
    
    @Test("Running RouteInserter twice")
    func runTwice() async throws {
        let routes = Group{
            BehindBothMiddlewares.self
            SecondTest.self
            ThirdTest.self
        }
        
        try await withApp { app in
            let duplicates = RouteInserter(to:app){
                routes
            }.duplicates
            #expect(duplicates.isEmpty)
            
            let secondDuplicated = RouteInserter(to:app){
                routes
            }.duplicates
            
            try #require(secondDuplicated.count == 3)
            #expect(secondDuplicated[0] == BehindBothMiddlewares.routeId)
            #expect(secondDuplicated[1] == SecondTest.routeId)
            #expect(secondDuplicated[2] == ThirdTest.routeId)
        }
    }
    
    func withApp(_ closure : @escaping (Application) async throws -> () ) async throws{
        
        let app = try await Application.make(.testing)
        do {
            try await closure(app)
        }
        catch {
            
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
}
