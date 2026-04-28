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
        
        try await withByPassLock {
            
            
            try await withApp { app in
                let routes : [any Registrable.Type] = [ TestRoute.self , SecondTest.self, ThirdTest.self ]
                let registrar = RouteRegistrar()
                
                registrar.routes = routes
                let duplicates = try registrar.register(on: app)
                
                #expect(duplicates.isEmpty)
            }
            
            RouteRegistrar.counter = 0
            try await withApp { app in
                let routes : [any Registrable.Type] = [ SecondTest.self , SecondTest.self, ThirdTest.self ]
                let registrar = RouteRegistrar()
                
                registrar.routes = routes
                let duplicates = try registrar.register(on: app)
                
                #expect(duplicates.count == 1)
                #expect(duplicates[0] == SecondTest.routeId)
            }
            
            RouteRegistrar.counter = 0
            try await withApp { app in
                let routes : [any Registrable.Type] = [ ThirdTestSimillar.self,ThirdTestSimillar.self , SecondTest.self, ThirdTest.self ]
                let registrar = RouteRegistrar()
                
                registrar.routes = routes
                let duplicates = try registrar.register(on: app)
                
                #expect(duplicates.count == 2)
                #expect(duplicates[0] == ThirdTestSimillar.routeId)
                #expect(duplicates[1] == ThirdTestSimillar.routeId)
            }
            
//            ///This time we didn't reset the counter, so it should throw
//            
//            try await withApp { app in
//                let routes : [any Registrable.Type] = [ TestRoute.self , SecondTest.self, ThirdTest.self ]
//                let registrar = RouteRegistrar()
//                
//                registrar.routes = routes
//                #expect(throws: RegisterationError.moreThanOnce){
//                    try registrar.register(on: app)
//                }
//                
//            }
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
