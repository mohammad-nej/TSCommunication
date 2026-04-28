//
//  Failable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//
import Foundation

public protocol Failable   {
    
    associatedtype Failure : ServerError
    associatedtype FailureCoder : EncoderDecoder = DefaultCoding
    
    ///encoder used for encoding server errors
    static var failureEncoder : JSONEncoder { get }
    
    //decoder used for decoding server errors
    static var failureDecoder : JSONDecoder { get }
    
    
}

public extension Failable {
    
    static var failureEncoder: JSONEncoder {
        FailureCoder.encoder
    
    }
    
    static var failureDecoder: JSONDecoder {
        FailureCoder.decoder
    }
}

///Type that indicates an error message received from server
public typealias ServerError = Codable&Sendable&Equatable&Error





///Default error format of vapor
public struct VaporError : ServerError, Hashable {
    public let error : Bool
    public let reason: String
    
    
    
    public init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}


