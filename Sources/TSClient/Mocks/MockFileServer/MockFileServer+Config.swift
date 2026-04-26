//
//  MockFileServer+Config.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation
import TSShared



public extension MockFileServer {
    
    var config : RequestConfig<Self> {
        return RequestConfig(server: .test, client: self)
    }
}
