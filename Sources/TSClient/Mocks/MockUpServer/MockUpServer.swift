//
//  MockUpServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation



///Mocks a server that can accept upload requests.
public struct MockUpServer<Out : Encodable> : Sendable , UpHttpClient{
    
    let uploadData : @Sendable (Data,URLRequest) async throws -> (Out, URLResponse)
    
    var encoder : JSONEncoder
    
    public func upload(for request : URLRequest, from data: Data, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {

        let (outputData,response) = try await uploadData(data, request)
        let decoded = try encoder.encodeIfNeeded(outputData)
        return (decoded, response)
    }
 
}



