//
//  TestInitializer+Vapor.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import VaporTesting
import TSShared


public extension TestingApplicationTester {
   
    ///Convenient function for testing your app
    ///
    ///You can test your routes with ease :
    ///```swift
    ///app.testing().test(MyRoute.self){request in
    /// let dto = MyRoute.InputData(...)
    /// try MyRoute.insert(dto, in : &request)
    ///}afterResponse:{response in
    /// let result = MyRoute.output(from : response)
    /// //....
    ///}
    @discardableResult
    func test<T:GetHttpRoute>(_ route : T.Type,
                               parameters : [String] = [],
                               headers : HTTPHeaders = [:],
                               body : ByteBuffer? = nil,
                               mode : URLCreationMode = .safe,
    beforeRequest: (inout TestingHTTPRequest) async throws -> () = { _ in },
    afterResponse: (TestingHTTPResponse) async throws -> () = { _ in }) async throws
    -> any TestingApplicationTester
    {
        let url = try T.path.urlValidPath(with: parameters, mode: mode)
        return try await self.test(
                    T.method.asVaporHTTPMethod,
                    url,
                    headers: headers,
                    body: body,
                    beforeRequest: beforeRequest,
                    afterResponse: afterResponse
        )
    }
}







