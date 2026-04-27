//
//  MockGetServer+config.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import TSShared
import Foundation

public extension MockGetServer where O : Sendable {
    
    ///A mock config for this mock server
    var config : RequestConfig<Self>{
        return RequestConfig(server: .test, client: self)
    }
}
