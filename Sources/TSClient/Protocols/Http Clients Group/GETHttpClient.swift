//
//  GETHttpClient.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation

public protocol GETHttpClient : _HttpClientable {
    func data(for : URLRequest,delegate: (any URLSessionTaskDelegate)?) async throws -> (Data,URLResponse)
}