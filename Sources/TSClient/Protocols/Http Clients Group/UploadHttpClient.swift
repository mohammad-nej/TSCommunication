//
//  UploadHttpClient.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation
#if os(Linux)
import FoundationNetworking
#endif

///a client that support streaming a file to server
public protocol UploadHttpClient : Sendable  {
    func upload(for: URLRequest, fromFile: URL,delegate: (any URLSessionTaskDelegate)?) async throws -> (Data,URLResponse)
}

public extension UploadHttpClient  where Self == URLSession{
    ///URLSession.shared instance
    static var shared : URLSession { .shared }
}
