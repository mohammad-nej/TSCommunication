//
//  MockGetResponder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation


///Mocks a GET only http server that can answer to download requests
///
///This can be used to test your client app with out reaching out to server , or can be replaced by your server
///if your user is offline for example
public struct MockGetServer<O : Encodable >: GETHttpClient, Sendable {
    
    public var encoder : JSONEncoder
    
    let download : @Sendable (URLRequest) async throws -> (O, URLResponse)
        
    public func data(for url : URLRequest, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        let (value,response) = try await download(url)
        let data = try encoder.encodeIfNeeded(value)
        return (data,response)
    }

    public init(responds: @Sendable @escaping (URLRequest) async throws -> (O,URLResponse) ){
        self.download = responds
        self.encoder = JSONEncoder()
    }
    
    public init(always value : O) where O : Sendable{
        self.download = { _ in
            return (value,URLResponse())
        }
        self.encoder = JSONEncoder()
    }
}






