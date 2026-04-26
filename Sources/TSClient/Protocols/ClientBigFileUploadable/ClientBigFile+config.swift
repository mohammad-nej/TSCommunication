//
//  Mock.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension ClientBigFileUploadable where OutputData : Sendable {
    ///A config that contains a mock server, which will always returns a constant value
    ///
    ///This config can be used for testing your application without connecting to real server
    static func mockConfig(always value : OutputData) -> RequestConfig<MockFileServer<OutputData>> {
        let server = MockFileServer(for: Self.self, always: value)
        return RequestConfig(server: .test, client: server)
    }
}
