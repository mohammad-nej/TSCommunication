//
//  GETHttpClient.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation
import TSShared

///a client that can only handle GET requests
public protocol GETHttpClient : Sendable  {
    func data(for : URLRequest,delegate: (any URLSessionTaskDelegate)?) async throws -> (Data,URLResponse)
}


public extension GETHttpClient where Self == URLSession {
    ///URLSession.shared instance
    static var shared : URLSession {
        URLSession.shared
    }
   
}


