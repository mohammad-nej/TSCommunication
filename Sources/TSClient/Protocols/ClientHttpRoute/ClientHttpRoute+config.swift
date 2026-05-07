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
    static func mockClient(always value : OutputData) -> MockUpServer<OutputData> {
      MockUpServer(for: Self.self, always: value)
    }
    
    ///Mock config that will always throw with your provided error
    static func mockClient(throws value : Self.Failure) -> MockUpServer<Self.Failure>{
        MockUpServer(for: Self.self, throws: value)
    }
}
