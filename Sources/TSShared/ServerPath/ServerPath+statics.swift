//
//  ServerPath+statics.swift
//  TSShared
//
//  Created by MohammavDev on 4/21/26.
//

public extension ServerPath {
    
    ///vapor anything parameter
    static let anything : ServerPath = "*"
    
    ///vapor catchall parameter
    static let catchAll : ServerPath = "**"
    
    ///Creates a path parameter with your provided name
    static func paramter(_ name : String) throws -> ServerPath {
        if name.hasPrefix(":"){
            return try ServerPath(string: name)
        }
        return try ServerPath(string: ":\(name)")
    }
}
