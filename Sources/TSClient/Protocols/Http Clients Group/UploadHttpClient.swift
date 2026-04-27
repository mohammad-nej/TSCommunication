//
//  UploadHttpClient.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation

///a client that support streaming a file to server
public protocol UploadHttpClient : _HttpClientable {
    func upload(for: URLRequest, fromFile: URL,delegate: (any URLSessionTaskDelegate)?) async throws -> (Data,URLResponse)
}
