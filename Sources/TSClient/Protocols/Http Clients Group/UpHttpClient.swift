//
//  for.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation

///A protocol for http client that uploads data to server
///
///This is mainly used for testing your application
public protocol UpHttpClient : _HttpClientable{
    func upload(for : URLRequest , from : Data,delegate: (any URLSessionTaskDelegate)?) async throws -> (Data,URLResponse)
 
}
