//
//  JSONCoder.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/26/26.
//

import Foundation




public extension JSONDecoder {
    
    func decodeIfNeeded<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        if type.self is Data.Type {
            return (data as! T)
        }
        
        return try self.decode(T.self, from: data)
    }
}


public extension JSONEncoder {
    func encodeIfNeeded<T: Encodable>(_ value: T) throws -> Data {
    
        if T.self is Data.Type {
            return (value as! Data)
        }
        
        return try self.encode(value)}
}
