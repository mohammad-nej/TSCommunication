//
//  FileName+Unchecked.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//


import Foundation



public extension FileName{
    
    ///Creates and Validates a FileName with your validation regex
    init(_ fullname : String, validation : some RegexComponent)throws{
        guard fullname.wholeMatch(of: validation) != nil else{
            throw FileNameError.invlaidFileName
        }
        self = .unchecked(fullname)
    }
    
    ///Creates and Validates a FileName with your validation regex
    static func validate(_ fullname : String , using regex : some RegexComponent) throws -> FileName {
        try .init(fullname, validation: regex)
    }
}
