//
//  Failable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//
import Foundation

public protocol Failable :  EncoderDecoder {
    associatedtype Failure : ServerError
}


///Type that indicates an error message received from server
public protocol ServerError : Codable , Sendable, Equatable {}



///Default error format of vapor
public struct VaporError : ServerError, Hashable {
    public let error : Bool
    public let reason: String
    
    public init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}
