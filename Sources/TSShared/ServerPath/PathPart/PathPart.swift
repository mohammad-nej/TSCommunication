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
///We didn't want to use `PathComponent` directly, cause that would need importing the entire `Vapor` package just for this matter.
///This type will also do some light validations on your input.
public struct PathPart : Communicatable, Hashable{
    public let value : String
    
    ///Creates a PathPart, throws if your string is invalid.
    public init(value: String) throws{
        guard value.wholeMatch(of: Self.validation) != nil || value == "*" || value == "**" else {
            throw ServerPathError.invalidPath
        }
        self.value = value
    }
    
    ///Creates your PathPart without any validation
    public init(unchecked value : String){
        self.value = value
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
    
    ///Checks if PathPart is a simple path
    public var isPath : Bool {
        return !self.isParameter && !self.isAnything && !self.isCatchAll
    }
    
    ///Check if it's Anything wildcard
    public var isAnything : Bool {
        return self.value == "*"
    }
    ///Check if it's CatchAll wildcard
    public var isCatchAll : Bool {
        return self.value == "**"
    }
    
    ///Vapor/Hummingbird anything wildcard
    public static let anything : PathPart = "*"
    
    ///Vapor/Hummingbird catchall wildcard
    public static let catchAll : PathPart = "**"
}

extension PathPart : ExpressibleByStringLiteral{
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = try! .init(value: value)
    }
}

