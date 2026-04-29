//
//  ServerTet+RoutTest.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//

import Foundation
import Vapor
import TSShared
import TSVapor
import VaporTesting



public extension ServerTest {
    
    ///Convenient function for testing your app
    ///
    ///You can test your routes with ease :
    ///```swift
    ///let tester = ServerTest(routes:[myRoute])
    ///tester.test(MyRoute.self){
    ///}afterResponse:{
    ///}
    ///```
    func test<T:GetHttpRoute>(_ route : T.Type,
                              parameters : [String] = [],
                              headers : HTTPHeaders = [:],
                              body : ByteBuffer? = nil,
                              mode : URLCreationMode = .safe,
//                              preparation :  @escaping AppPreparationClosure ,
                              beforeRequest: (inout TestingHTTPRequest) async throws -> () = { _ in },
                              afterResponse: (TestingHTTPResponse) async throws -> () = { _ in }) async throws
    
    {
        

        return try await self.withApp { app in
            
            try await app.testing().test(
                T.self,
                headers: headers,
                body: body,
                beforeRequest: beforeRequest,
                afterResponse: afterResponse
            )
        }
    }

    
}
