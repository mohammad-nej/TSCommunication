//
//  MockGetResponder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif

///Mocks a GET only http server that can answer to download requests
///
///This can be used to test your client app with out reaching out to server
///```swift
///MockGetServer<String> { request in
/// return ("data",URLResponse())
///}
///```
public struct MockGetServer<O : Encodable >: GETHttpClient, Sendable {
        
    public var encoder : JSONEncoder
    
    let download : @Sendable (URLRequest) async throws -> (O, URLResponse)
        
    public func data(for url : URLRequest, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        let (value,response) = try await download(url)
       
        let data = try encoder.encode(value)
       
        return (data,response)
    }

    ///Initializer with a closure to run
    public init(responds: @Sendable @escaping (URLRequest) async throws -> (O,URLResponse) ){
        self.download = responds
        self.encoder = JSONEncoder()
    }
    
    ///Always returns the provided value
    public init(always value : O) where O : Sendable{
        self.download = { _ in
            return (value,URLResponse())
        }
        self.encoder = JSONEncoder()
    }
}






