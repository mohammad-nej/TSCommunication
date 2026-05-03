//
//  TSShared+.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import TSShared
import Vapor

///Coverts `TSShared.HttpMethod` to `Vapor.HTTPMethod`
public extension HttpMethod {
    ///Convert TSShared.HttpMethod to to vapors HTTPMethod
    var asVaporHTTPMethod: HTTPMethod {
        Vapor.HTTPMethod(rawValue: self.rawValue)
    }
}

public extension Vapor.HTTPMethod {
    var asTSSharedHttpMethod: TSShared.HttpMethod {
        
        TSShared.HttpMethod(rawValue: self.rawValue)
    }
}
