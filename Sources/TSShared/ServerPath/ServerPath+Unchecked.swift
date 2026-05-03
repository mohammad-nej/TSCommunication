//
//  ServerPath+Unchecked.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//

import Foundation



extension ServerPath {
    
    ///Creates a ServerPath without validating you input
    public init(unchecked value : String){
        let parts =  value
            .split(separator: "/")
            .map{ element in
                PathPart(unchecked: String(element))
            }
        self = ServerPath(parts: parts)
    }
    
    ///Creates a ServerPath without validating you input
    public static func unchecked(_ value : String) -> ServerPath {
        .init(unchecked: value)
    }
    
    
    
}
