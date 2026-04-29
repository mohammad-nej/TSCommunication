//
//  RouteProtocol+.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import TSShared
import VaporTestUtils
import TSVapor
import Vapor

public extension GetHttpRoute {
    
    ///Converts vapor response to your output and pass it out
    static func output(from response : TestingHTTPResponse, using decoder : (any ContentDecoder)? = nil) throws -> Self.OutputData {
        if let decoder{
            return try response.content.decode(OutputData.self, using: decoder)
        }
        return try response.content.decode(OutputData.self)
    }
}





//since all routes conform to GetHttpRoute , this extension will be available to all routes
public extension GetHttpRoute where Self : FileTransferMethodable , Self : VaporRespondable, Self : InnerMiddewareContainer {
    
    ///Convenient function for testing your app
    ///
    ///You can test your routes with ease :
    ///```swift
    ///let prepare : AppPreparationClosure = { app in
    /// //setup your db , ...
    ///}
    ///MyRoute.test(prepare:prepare){ req in
    ///}afterResponse:{ response in
    ///}
    ///```
    static func test(
        parameters : [String] = [],
        headers : HTTPHeaders = [:],
        body : ByteBuffer? = nil,
        mode : URLCreationMode = .safe,
        prepare : @escaping AppPreparationClosure ,
        beforeRequest: (inout TestingHTTPRequest) async throws -> () = { _ in },
        afterResponse: (TestingHTTPResponse) async throws -> () = { _ in }) async throws
    
    {
        let serverTester = ServerTest(preparation: prepare)
        
        try await serverTester.withApp { app in
            
            try await app.testing().test(
                Self.self,
                parameters: parameters,
                headers: headers,
                body: body,
                mode:mode,
                beforeRequest: beforeRequest,
                afterResponse: afterResponse
            )
            
        }

    }
        
    ///This will insert current route to you server
    ///
    ///This can be useful for routes that requires no setups to perform
    static var insertToApp : AppPreparationClosure {
        return { app in
            
            try RouteInserter(to: app) {
                Self.init()
            }
        }
    }
}
