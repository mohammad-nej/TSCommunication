//
//  PathPart.swift
//  TSShared
//
//  Created by MohammavDev on 4/21/26.
//

import Foundation


///A single piece of path, which can be either a path or parameter
///
///This type is basically the equivalent of `Vapor.PathComponent`.
///
///We didn't want to use `PathComponent` directly
public struct PathPart : Communicatable, Hashable{
    public let value : String
    
    public init(value: String) throws{
        guard !value.isEmpty else {
            throw ServerPathError.pathIsEmpty
        }
        
        if value.hasPrefix("/"){
            let dropped = value.dropFirst()
            if dropped.contains("/"){
                throw ServerPathError.partCanNotContainSlash
            }
            self.value = String(dropped)
        }else if value.hasPrefix(":"){
            let dropped = value.dropFirst()
            if dropped.contains(":"){
                throw ServerPathError.commaIsNotValid
            }
            self.value = value
        }else if value.hasPrefix("*"){
            if value == "*" || value == "**"{
                self.value = value
                return
            }
            //path like *something is not considered valid path
            throw ServerPathError.invalidPath
        }
        else{
            //TODO: this area can be improved by using a regex to match both characters at the same time
            if value.contains("/"){
                throw ServerPathError.partCanNotContainSlash
            }
            if value.contains(":"){
                throw ServerPathError.commaIsNotValid
            }
            self.value = value
        }
    }
}

extension PathPart : CustomStringConvertible{
    
    ///Returns the value, by removing any leading `:` or `/`
    public var correctedValue : String {
        if self.value.starts(with: ":"){
            return String(self.value.dropFirst())
        }
        if self.value.starts(with: "/"){
            return String(self.value.dropFirst())
        }
        return self.value
    }
    
    public var description: String {
        return self.value
    }
    
    public var isParameter: Bool {
        return self.value.hasPrefix(":")
    }
    
    public var isPath : Bool {
        return !self.isParameter && !self.isAnything && !self.isCatchAll
    }
    
    public var isAnything : Bool {
        return self.value == "*"
    }
    
    public var isCatchAll : Bool {
        return self.value == "**"
    }
    
    public static let anything : PathPart = "*"
    
    public static let catchAll : PathPart = "**"
}

extension PathPart : ExpressibleByStringLiteral{
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = try! .init(value: value)
    }
}

