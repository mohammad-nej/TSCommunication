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
    static func mockClient(always value : OutputData) ->MockFileServer<OutputData> {
         MockFileServer(for: Self.self, always: value)
        
    }
    
    ///Mock config that will always throw with your provided error
    static func mockClient(throws value : Self.Failure) -> MockFileServer<Self.Failure>  {
         MockFileServer(for: Self.self, throws: value)
        
    }

}
