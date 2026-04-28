//
//  CollectionBuilderTests.swift
//  Whisper
//
//  Created by MohammavDev on 4/20/26.
//

import Testing
import VaporTesting
import TSVaporTestSupport
import Vapor
@testable import TSVapor
import TSShared








@Suite("Test Collection Builder and middlewares",.serialized)
struct MiddlewareBuilderTests{
    
    @Test("Adding a test middleware")
    func addingMiddleware() async throws {
        try await withByPassLock {
            
            
            let test = ServerTest(routes: [],builders: [])
            try await test.withApp{ app in
                
                try RouteInserter(to: app){
                    
                    With(middlewares:[TestMiddleWare2()]){
                        With(middleware:TestMiddleWare()) {
                            TestRoute()
                        }
                    }
                }
                
                
                try await app.testing().test(TestRoute.self){ request in
                    try request.content.encode("This is my content")
                    
                }afterResponse: { response in
                    //                try #require(response.status == .ok)
                    
                    let answer = try TestRoute.output(from: response)
                    #expect(answer)
                    
                    
                }
                
            }
        }
    }
}
