//
//  PathPart+Inits.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//

import Foundation

public extension PathPart{
    
    ///Validates your input with your provided Regex
    ///
    ///This function will use `wholeMatch(of: some RegexComponent)`
    /// - Important: `*` and `**` will always validate to true, don't include them to in your regex
    init(_ value : String, using regex : some RegexComponent) throws{
        guard value.wholeMatch(of: regex) != nil || value == "*" || value == "**" else {
            throw ServerPathError.invalidPath
        }
        self = .init(unchecked: value)
    }
}
