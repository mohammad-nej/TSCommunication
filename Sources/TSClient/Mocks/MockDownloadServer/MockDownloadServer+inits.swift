//
//  MockDownloadServer+inits.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/4/26.
//
import TSShared
import Foundation

public extension MockDownloadServer {
    ///A mock download server that can respond to requests
    init<T:FileDownloadable>(_ type : T.Type , download : @escaping @Sendable (URLRequest, (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) ){
        self._download = download
    }
    
    ///A mock get server that will always responds with a constant value
    init<T:FileDownloadable>(_ type : T.Type , always value : Data){
        self._download = { _, _ in (value, URLResponse()) }
    }
    
    ///Always returns the provided server error
    init<T:FileDownloadable>(_ type : T.Type,throws value : T.Failure) throws {
        let encoded = try T.failureEncoder.encode(value)
        self._download = { _, _ in (encoded, URLResponse()) }
    }
}
