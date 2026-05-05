//
//  TestInitializer+Vapor.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import VaporTesting
import TSShared

///Can be used to prepare your `Application` object for staring your tests.
///
///For example you can prepare your database in here
///```swift
///let prepare = { app in
/// //prepare your db
/// //do migrations
///}
///```
public typealias AppPreparationClosure = @Sendable (Application) async throws -> Void

public extension TestingApplicationTester {
   
    ///Lets you test your routes
    ///
    /// You can test your routes with ease :
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
                               mode : URLCreationMode = .checked,
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







