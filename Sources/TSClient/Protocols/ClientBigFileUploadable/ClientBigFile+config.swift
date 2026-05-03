//
//  Mock.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension ClientLargeFileUploadable where OutputData : Sendable {
    ///A config that contains a mock server, which will always returns a constant value
    ///
    ///This config can be used for testing your application without connecting to real server
    static func mockConfig(always value : OutputData) -> RequestConfig<MockFileServer<OutputData>> {
        let server = MockFileServer(for: Self.self, always: value)
        return RequestConfig(server: .test, client: server)
    }
    
    ///Mock config that will always throw with your provided error
    static func mockConfig(throws value : Self.Failure) -> RequestConfig<MockFileServer<Self.Failure>>  {
        let server = MockFileServer(for: Self.self, throws: value)
        return RequestConfig(server: .test, client: server)
    }

}
