//
//  MockHttpServer+config.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//


import Foundation
import TSShared


public extension MockHttpServer {
    //config for this mock server
    var config : RequestConfig<Self> {
        .init(server: .test, client: self)
    }

}
