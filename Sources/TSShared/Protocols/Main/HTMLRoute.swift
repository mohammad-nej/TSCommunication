//
//  HTMLRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/29/26.
//

import Foundation

public protocol HTMLRoute : InputOutputableRoute where OutputData == HTML {}


public extension HTMLRoute {
    static var method: HttpMethod { .POST }
}
