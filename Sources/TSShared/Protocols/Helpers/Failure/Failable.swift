//
//  Failable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//
import Foundation


///Used to handle failure and server errors
///
///Client side protocols will use this decoder to decode errors sent by server.
///
/// - Important: Since there is no way to force server to send errors in a specific format,
///this is just a contract that you **must**  obey in server-side.
public protocol Failable{
    
    ///Type of the error sent by server
    associatedtype Failure : ServerError
    
    ///EncoderDecoder used to encode/decode data
    associatedtype FailureCoder : EncoderDecoder = DefaultCoding
    
    ///encoder used for encoding server errors
    static var failureEncoder : JSONEncoder { get }
    
    //decoder used for decoding server errors
    static var failureDecoder : JSONDecoder { get }
    
    
}

///Type that indicates an error message received from server
public typealias ServerError = Codable&Sendable&Equatable&Error

public extension Failable {
    
    static var failureEncoder: JSONEncoder {
        FailureCoder.encoder
    
    }
    
    static var failureDecoder: JSONDecoder {
        FailureCoder.decoder
    }
}










