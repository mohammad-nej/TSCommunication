//
//  MockDownloadServer.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/3/26.
//

import TSShared
import Foundation
#if os(Linux)
import FoundationNetworking
#endif

///Mock server that downloads a binary Data from server
///
public struct MockDownloadServer : Sendable , GETHttpClient{
    
    let _download : @Sendable (URLRequest, (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    
    public func data(for url: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        return try await _download(url,delegate)
    }
    
    public init(_download: @Sendable @escaping (URLRequest, (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)) {
        self._download = _download
    }
}

