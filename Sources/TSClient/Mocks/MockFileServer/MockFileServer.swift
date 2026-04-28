//
//  MockFileServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation



///Mocks a server that can accept stream of files
///
///You can create a mock sever that responds to requests
///```swift
///MockFileServer<Bool>{ fileUrl,request in
/// //do your stuff
/// return (true,URLResponse())
///}
///```
public struct MockFileServer<Out : Encodable> : Sendable , UploadHttpClient{
    
//    private let uploadData : @Sendable (Data,URLRequest) async throws -> (Out, URLResponse)
    let uploadFile : @Sendable (URL,URLRequest) async throws -> (Out, URLResponse)
    
    public var encoder : JSONEncoder
 
    
    public func upload(for request : URLRequest, fromFile url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        let (out,response) = try await uploadFile(url,request)
        let outputData = try encoder.encode(out)
        return (outputData,response)
    }
 
    ///Creates a mock  that runs a closure upon being called
    public init(uploadFile: @Sendable @escaping (URL, URLRequest) async throws -> (Out, URLResponse)) {
        self.uploadFile = uploadFile
        self.encoder = JSONEncoder()
    }
    
    ///Always returns the provided value
    public init(always value : Out) where Out : Sendable {
        let response : @Sendable (URL,URLRequest) async throws -> (Out, URLResponse) = { _,_ in
            return (value,URLResponse())
        }
        
        self.uploadFile = response
        self.encoder = JSONEncoder()
    }

    
}




