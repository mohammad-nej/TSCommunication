//
//  TSShared+.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import TSShared
import Vapor


public extension Array where Element == PathComponent{
    var pathString : String{
        self.map(\.description).joined(separator: "/")
    }
}

public extension HttpMethod {
    ///Convert TSShared.HttpMethod to to vapors HTTPMethod
    var asVaporHTTPMethod: HTTPMethod {
        Vapor.HTTPMethod(rawValue: self.rawValue)
    }
}
