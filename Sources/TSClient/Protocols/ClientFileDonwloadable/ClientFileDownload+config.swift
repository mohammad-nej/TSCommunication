//
//  ClientFileDownload+config.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/3/26.
//
import Foundation
import TSShared

public extension FileDownloadable where Self : EncoderDecoder {
    
    ///A config that contains a mock server, which will always returns a constant value
    ///
    ///This config can be used for testing your application without connecting to real server
    static func mockConfig(always value : Data) -> RequestConfig<MockDownloadServer> {
        let server = MockDownloadServer(Self.self, always: value)
        return RequestConfig(server: .test, client: server)
    }
    
    ///Mock config that will always throw with your provided error
    static func mockConfig(throws value : Self.Failure) throws -> RequestConfig<MockDownloadServer> {
        let server = try MockDownloadServer(Self.self, throws: value)
        return RequestConfig(server: .test, client: server)
    }
}
