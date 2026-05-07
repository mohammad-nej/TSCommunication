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
    static func mockClient(always value : Data) -> MockDownloadServer {
       MockDownloadServer(Self.self, always: value)
       
    }
    
    ///Mock config that will always throw with your provided error
    static func mockClient(throws value : Self.Failure) throws -> MockDownloadServer {
        try MockDownloadServer(Self.self, throws: value)
        
    }
}
