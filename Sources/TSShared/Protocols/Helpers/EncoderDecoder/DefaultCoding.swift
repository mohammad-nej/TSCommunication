//
//  DefaultCodingConfig.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//
import Foundation

///Default Encoder/Decoder of this package which is just a default JSONEncoder/JSONDecoder
public struct DefaultCoding : EncoderDecoder , Sendable {
    public static let encoder: JSONEncoder = JSONEncoder()
    public static let decoder: JSONDecoder = JSONDecoder()
        
    public init() {}
}
public extension EncoderDecoder where Self == DefaultCoding {
    static var `default` : DefaultCoding { DefaultCoding() }
}
