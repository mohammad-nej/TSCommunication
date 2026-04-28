//
//  RouteBuilder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//

import TSShared
import Foundation
import Vapor

///Any type that contains an innerMiddlewareBuilder
///
///This protocol is used internally
public protocol InnerMiddewareContainer {
    var innerMiddleware: InnerMiddleWareBuilder { get }
}


