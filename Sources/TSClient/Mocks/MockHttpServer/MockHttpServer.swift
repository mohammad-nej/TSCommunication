//
//  MockHttpServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/25/26.
//

import Foundation
import TSShared



///A general purpose Http mock server
///
///This is mocked can be passed in to all routes:
///```swift
///let mock = MockHttpServer { data, req in
///    return (data,URLResponse())
///} downloadData: { request in
///    let text = "Hello, World!".data(using: .utf8)!
///    return (text, URLResponse())
///} uploadFile: { url, request in
///    let sampleFile = "A sample file".data(using: .utf8)!
///    return (sampleFile, URLResponse())
///}
///let config = mock.config
///
///MySampleRoute.get(config: config)
///```
///While this object can be used for testing, You can even use it as a backup offline server.
///
///```swift
///let offlineServer = MockHttpServer{data , req in
/// //save this request in local db, to be done later
/// return (Data(),URLResponse())
///}//...
///
/////Then in your app you can check
///MyRoute.get(config: isOnline ? realServer : offlineServer)
///```
public struct MockHttpServer: Sendable , HttpClient {
    
    private let uploadData : @Sendable (Data,URLRequest) async throws -> (Data,URLResponse)
    private let downloadData : @Sendable (URLRequest) async throws -> (Data,URLResponse)
    private let uploadFile : @Sendable (URL,URLRequest) async throws -> (Data,URLResponse)
    
    ///Mocks uploading a data to server
    public func upload(for url : URLRequest, from data : Data, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return try await uploadData(data,url)
    }
    
    ///Mocks downloading data from server, mainly used by .get requests
    public func data(for url: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        
        return try await downloadData(url)
   
    }
    
    ///Mocks uploading a large file to server
    public func upload(for request: URLRequest, fromFile url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return try await uploadFile(url,request)
        
    }
 
    ///Creates a mock http server that can respond to any route
    public init(uploadData: @Sendable @escaping (Data, URLRequest) async throws -> (Data, URLResponse),
                downloadData: @Sendable @escaping (URLRequest) async throws -> (Data, URLResponse),
                uploadFile: @Sendable @escaping (URL, URLRequest) async throws -> (Data, URLResponse),
               ) {
        self.uploadData = uploadData
        self.downloadData = downloadData
        self.uploadFile = uploadFile
  
    }
    
}





