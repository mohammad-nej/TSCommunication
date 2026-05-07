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







enum OneMiddleWare : ServerLargeFileUploadable {
    static var closure: @Sendable (Vapor.Request) async throws -> Bool{
        
        return { req in
            
            let headers = req.headers["Test-Header"]
                
            if headers.count == 1 {
                return true
            }
            return false
        }
        
        
    }
    
    typealias InputData = String
    
    static let path: TSShared.ServerPath = "uploadMyFile"
    
    
}

@Suite("Test Collection Builder and middlewares",.serialized)
struct MiddlewareBuilderTests{
    
    @Test("test Group builder")
    func testGroupBuilder() throws{
        
        let first = Group{
            OneMiddleWare.self
            BehindNoMiddleware.self
            WebSocketRoute.self
        }
        
        try #require(first.routes.count == 3)
        #expect(first.routes[0].routeId == OneMiddleWare.routeId)
        #expect(first.routes[1].routeId == BehindNoMiddleware.routeId)
        #expect(first.routes[2].routeId == WebSocketRoute.routeId)
        let second = Group{
            BehindBothMiddlewares.self
            first
        }.routes
        
        try #require(second.count == 4)
        
        #expect(second[0].routeId == BehindBothMiddlewares.routeId)
        #expect(second[1].routeId == OneMiddleWare.routeId)
        #expect(second[2].routeId == BehindNoMiddleware.routeId)
        #expect(second[3].routeId == WebSocketRoute.routeId)
    }
    
    @Test("Adding a test middleware")
    func addingMiddleware() async throws {
        let some = With(middleware: TestMiddleWare()) {
            BehindBothMiddlewares.self
        }
        let test = ServerTest(){ app in
             RouteInserter(to: app){
                
                With(middlewares:[TestMiddleWare2()]){
                    some
                    BehindTest2Middleware.self
                }
                
                With(middleware: TestMiddleWare()) {
                    BehindTestMiddleware.self
                }
                
                BehindNoMiddleware.self
            }
        }
        try await test.withApp{ app in
            
            try await test.test(BehindNoMiddleware.self){ req in
            }afterResponse: { response in
                let output = try BehindNoMiddleware.output(from:response)
                #expect(output)
            }
            
            try await test.test(BehindTestMiddleware.self){ req in
            }afterResponse: { response in
                let output = try BehindTestMiddleware.output(from:response)
                #expect(output)
            }
            
            try await test.test(BehindTest2Middleware.self){ req in
            }afterResponse: { response in
                let output = try BehindTest2Middleware.output(from:response)
                #expect(output)
            }
            
            try await app.testing().test(BehindBothMiddlewares.self){ request in
                try request.content.encode("This is my content")
                
            }afterResponse: { response in
                //                try #require(response.status == .ok)
                
                let answer = try BehindBothMiddlewares.output(from: response)
                #expect(answer)
                
                
            }
            
        }
        
    }
}
