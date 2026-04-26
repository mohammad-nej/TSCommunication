//
//  ServerPath+ArrayLitteral.swift
//  TSShared
//
//  Created by MohammavDev on 4/21/26.
//

import Foundation



extension ServerPath : ExpressibleByArrayLiteral{
    typealias Element = ServerPath
    
    public init(arrayLiteral elements: ServerPath...) {
        let parts = elements.flatMap { serverPath in
            serverPath.parts
        }
        
        self = .init(parts: parts)
    }
}
