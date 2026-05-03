//
//  ClientHttpRoute+config.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation


public extension ClientHttpRoute where OutputData : Sendable {
    
    ///A config that contains a mock server, which will always returns a constant value
    ///
    ///This config can be used for testing your application without connecting to real server
    static func mockConfig(always value : OutputData) -> RequestConfig<MockUpServer<OutputData>> {
        let server = MockUpServer(for: Self.self, always: value)
        return RequestConfig(server: .local, client: server)
    }
    
    ///Mock config that will always throw with your provided error
    static func mockConfig(throws value : Self.Failure) -> RequestConfig<MockUpServer<Self.Failure>> {
        let server = MockUpServer(for: Self.self, throws: value)
        return RequestConfig(server: .local, client: server)
    }
}
