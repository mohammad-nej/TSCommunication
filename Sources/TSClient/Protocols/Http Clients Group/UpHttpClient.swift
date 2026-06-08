//
//  for.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation
#if os(Linux)
import FoundationNetworking
#endif

///A client that can upload data to server
///
///This is mainly used for testing your application
public protocol UpHttpClient : Sendable {
    func upload(for : URLRequest , from : Data,delegate: (any URLSessionTaskDelegate)?) async throws -> (Data,URLResponse)
 
}


public extension UpHttpClient where Self == URLSession {
    ///URLSession.shared instance
    static var shared : URLSession { .shared }
}
