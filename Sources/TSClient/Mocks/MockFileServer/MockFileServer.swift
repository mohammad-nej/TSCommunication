//
//  MockFileServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation



///Mocks a server that can accept stream of files
public struct MockFileServer<Out : Encodable> : Sendable , UploadHttpClient{
    
//    private let uploadData : @Sendable (Data,URLRequest) async throws -> (Out, URLResponse)
    let uploadFile : @Sendable (URL,URLRequest) async throws -> (Out, URLResponse)
    
    public var encoder : JSONEncoder
 
    
    public func upload(for request : URLRequest, fromFile url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        let (out,response) = try await uploadFile(url,request)
        let outputData = try encoder.encodeIfNeeded(out)
        return (outputData,response)
    }
 
    
    public init(uploadFile: @Sendable @escaping (URL, URLRequest) async throws -> (Out, URLResponse)) {
        self.uploadFile = uploadFile
        self.encoder = JSONEncoder()
    }
}




