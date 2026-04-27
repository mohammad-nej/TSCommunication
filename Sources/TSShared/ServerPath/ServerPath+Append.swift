//
//  ServerPath+Append.swift
//  TSShared
//
//  Created by MohammavDev on 4/21/26.
//

public extension ServerPath {
    
    ///Add a path string to the end of the current path
    mutating func append(string : String) throws {
        let path = try ServerPath(string: string)
        self.parts.append(contentsOf: path.parts)
    }
    
    ///Add a path to the beginning of the current path
    mutating func prepend(string : String) throws {
        
        let path = try ServerPath(string: string)
        self.parts = path.parts + self.parts
    }
    
    ///Creates a new path by adding  to the end of the current path
    func appending(string : String) throws -> ServerPath {
        var newPath = self
        try newPath.append(string: string)
        return newPath
    }
    
    ///Creates a new path by adding  to the beginning of the current path
    func prepending(string : String) throws -> ServerPath {
        var newPath = self
        try newPath.prepend(string: string)
        return newPath
    }
}
