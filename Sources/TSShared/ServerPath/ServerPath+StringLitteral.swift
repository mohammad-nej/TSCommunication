//
//  ServerPath+ArrayLitteral.swift
//  TSShared
//
//  Created by MohammavDev on 4/21/26.
//
import Foundation

extension ServerPath : ExpressibleByStringLiteral {
    

    
    /// - Warning: This function will crash if your entered path is invalid
    public init(stringLiteral value: String) {
        
        let parts = value
            .split(separator: "/")
            .map{ element in
                let part = try! PathPart(value: String(element))

                return part
            }
        
        self =  .init(parts: parts)
    }
    
    ///Creates a server path from a string value
    public init(string value : String) throws {
        let parts = try value
            .split(separator: "/")
            .map{ element in
                 try PathPart(value: String(element))
            }
        self = ServerPath(parts: parts)
    }
}
