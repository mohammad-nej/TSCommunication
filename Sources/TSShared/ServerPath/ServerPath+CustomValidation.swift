//
//  ServerPath+CustomValidation.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//

import Foundation



extension ServerPath {
        
    ///Validates your ServerPath using your provided regex
    ///
    /// - Important: Your input will be first seperated by "/", then regex will apply to each PathPart separately.
    ///
    ///This initializer will use `wholeMatch(of:Regex)`against each PathPart
    /// ```swift
    /// let path = "/users/admin"
    /// let serverPath = try ServerPath(path,validation: regex)
    /////Your regex will be matched against  "user" and "admin" separately.
    /// ```
    /// - Important: `*` and `**` will always validate to true for each PathPart cause Vapor and Hummingbird use them as special parameters.
    public init(_ value : String , validation : some RegexComponent) throws{
        let parts = try value
            .split(separator: "/")
            .map{ element in
                try PathPart(String(element), using: validation)
            }
        self = ServerPath(parts: parts)
        
        
    }
    
    ///Creates and validates your ServerPath using your provided regex
    ///
    /// - Important: Your input will be first seperated by "/", then regex will apply to each PathPart separately.
    ///
    ///This initializer will use `wholeMatch(of:Regex)`against each PathPart
    /// ```swift
    /// let path = "/users/admin"
    /// let serverPath = try ServerPath(path,validation: regex)
    /////Your regex will be matched against  "user" and "admin" separately.
    /// ```
    public static func validate(_ value : String , using regex : some RegexComponent) throws -> ServerPath{
        try .init(value, validation: regex)
    }
}
