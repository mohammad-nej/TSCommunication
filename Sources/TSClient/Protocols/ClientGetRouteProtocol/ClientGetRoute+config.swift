//
//  ClientGetRoute+config.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import TSShared
import Foundation


public extension OutputableRoute where OutputData : Sendable , Self : EncoderDecoder {
    
    ///A config that contains a mock server, which will always returns a constant value
    ///
    ///This config can be used for testing your application without connecting to real server
    static func mockConfig(always value : OutputData) -> RequestConfig<MockGetServer<OutputData>> {
        let server = MockGetServer(for: Self.self, always: value)
        return RequestConfig(server: .test, client: server)
    }
    
    ///Mock config that will always throw with your provided error
    static func mockConfig(throws value : Self.Failure) -> RequestConfig<MockGetServer<Self.Failure>> {
        let server = MockGetServer(for: Self.self, throws: value)
        return RequestConfig(server: .test, client: server)
    }
}
