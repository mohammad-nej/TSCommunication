//
//  ClientHTMLRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 6/7/26.
//
import Foundation
import TSShared



public protocol ClientHTMLRoute : ClientHttpRoute where OutputData == HTML {}



public extension ClientHTMLRoute {
    static var timeoutInterval: TimeInterval? {
        nil
    }
    
    static public var method: HttpMethod { .POST}
}
