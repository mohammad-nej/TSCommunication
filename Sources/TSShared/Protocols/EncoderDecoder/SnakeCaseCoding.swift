//
//  RouteTest.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//




import Foundation


public struct SnakeCaseCoding : EncoderDecoder, Sendable   {
    public static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    public static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    public init() {}
}

public extension EncoderDecoder where Self == SnakeCaseCoding {
    static var snakeCase : SnakeCaseCoding { SnakeCaseCoding() }
}
