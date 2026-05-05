//
//  MockDownloadServer+config.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/4/26.
//

import TSShared
import Foundation



public extension MockDownloadServer {
    ///Creates a ``RequestConfig`` for this server
    var config : RequestConfig<Self> {
        return .init(server: .test, client: self)
    }
}
