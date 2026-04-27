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
import TSVapor
import TSShared



struct TestRoute : ServerFileUploadable {
   static var closure: @Sendable (Vapor.Request) async throws -> Bool {
       return { request in
           let values = request.headers["Test-Header"]
           
           guard values.count == 2 else { throw Abort(.badRequest)}
           
           
           
           guard values[0] == "Middle ware 2 is working" else {
               return false
           }
           
           guard values[1] == "Middle ware 1 is working" else {
               return false
           }
           
           return true
       }
   }
   
   typealias InputData = String
   
   typealias OutputData = Bool
   
   static let path: ServerPath = "testPath"
   
   static let method: TSShared.HttpMethod = .post
   
}


@Suite("Test Collection Builder and middlewares",.serialized)
struct MiddlewareBuilderTests{
    
    struct TestMiddleWare2 : AsyncMiddleware {
        func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
            request.headers.add(name: "Test-Header", value: "Middle ware 2 is working")
            return try await next.respond(to: request)
        }
    }
    
    struct TestMiddleWare : AsyncMiddleware {
        func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
            
            request.headers.add(name: "Test-Header", value: "Middle ware 1 is working")
            return try await next.respond(to: request)
        }
    }
    
     
    
    
    @Test("Adding a test middleware")
    func addingMiddleware() async throws {
    
        let builder = MiddlewareBuilder()
        builder
            .build{ group in
                group.add(middleware:TestMiddleWare2())
                group.group(appending:TestMiddleWare()) { group in
                    group.add(route:TestRoute.self)
                }
        }

        
        let test = ServerTest(routes: [],builders: [builder])
        try await test.withApp{ app in
         
            try await app.testing().test(TestRoute.self){ request in
                try request.content.encode("This is my content")
                
            }afterResponse: { response in
                try #require(response.status == .ok)
                
                let answer = try TestRoute.output(from: response)
                #expect(answer)
                
                
            }
            
        }
    }
}
