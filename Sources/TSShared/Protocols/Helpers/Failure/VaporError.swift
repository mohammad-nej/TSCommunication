//
//  VaporError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//


import Foundation

///Default error format of Vapor
public struct VaporError : ServerError, Hashable {
    public let error : Bool
    public let reason: String
    
    
    
    public init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}
