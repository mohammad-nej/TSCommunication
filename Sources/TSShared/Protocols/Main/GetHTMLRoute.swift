//
//  GetHTMLRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 6/7/26.
//

import Foundation

public protocol GetHTMLRoute : OutputableRoute where OutputData == HTML {}


public extension GetHTMLRoute {
    static var method: HttpMethod { .GET }
}
