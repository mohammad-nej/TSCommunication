//
//  used.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import TSShared
import Foundation
import Vapor

///Any type that has [any Groupable.Type]
///
///This protocol used internally, don't conform to it
public protocol BuildableBlock {
    var routes : [any Groupable.Type] { get }
}
