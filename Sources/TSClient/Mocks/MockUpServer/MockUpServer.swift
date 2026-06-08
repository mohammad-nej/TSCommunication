//
//  MockUpServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif


///Mocks a server that can accept upload requests.
///
///You can create a mock that responds to your input
///```swift
///MockUpServer { data, request in
/// //procces data
/// return (output,URLResponse())
///}
///```
public struct MockUpServer<Out : Encodable> : Sendable , UpHttpClient{
    
    let uploadData : @Sendable (Data,URLRequest) async throws -> (Out, URLResponse)
    
    var encoder : JSONEncoder
    
    public func upload(for request : URLRequest, from data: Data, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {

        let (outputData,response) = try await uploadData(data, request)
        let decoded = try encoder.encode(outputData)
        return (decoded, response)
    }
    
    ///Creates a mock  that runs a closure upon being called
    public init(uploadData: @Sendable @escaping (Data, URLRequest) async throws -> (Out, URLResponse)) {
        self.uploadData = uploadData
        self.encoder = JSONEncoder()
    }
 
    ///Always returns the provided value
    public init(always value : Out) where Out : Sendable {
        let response : @Sendable (Data,URLRequest) async throws -> (Out,URLResponse) = { _,_ in
            return (value,URLResponse())
        }
        
        self.uploadData = response
        self.encoder = JSONEncoder()
    }
    
    
}



