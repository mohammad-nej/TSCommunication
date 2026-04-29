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




func test(){
    let values = Group{
        OneMiddleWare.self
    }
    
    
    try! RouteInserter(to:Application()){
        With(middleware: TestMiddleWare()) {
            values
        }
    }
    
}


struct OneMiddleWare : ServerBigFileUploadable {
    static var closure: @Sendable (Vapor.Request) async throws -> Bool{
        
        return { req in
            
            let headers = req.headers["Test-Header"]
                
            if let header = headers.first, headers.count == 1 {
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
    
    @Test("Adding a test middleware")
    func addingMiddleware() async throws {
        
        let test = ServerTest(){ app in
            try RouteInserter(to: app){
                
                With(middlewares:[TestMiddleWare2()]){
                    With(middleware:TestMiddleWare()) {
                        TestRoute()
                    }
                    
                    OneMiddleWare()
                }
            }
        }
        try await test.withApp{ app in
            
            
            try await test.test(OneMiddleWare.self){ req in
                OneMiddleWare.upload(Data(), in: &req)
            }afterResponse: { respose in
                let value = try OneMiddleWare.output(from: respose)
                #expect(value)
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
