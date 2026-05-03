//
//  FileName.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation



///Type representing a filename (with it's extension)
///
///Initializers of this type will do some validations on the input. For example it will throw error
///if input is empty , or has special characters in it.
///```swift
/////This initializer might crash during initialization if your input is invalid
///let filename : FileName = "myfile.txt"
///
/////This initializer will safely throw
///let filename : FileName = try Filename("myfile.txt")
///
/////This initializer will bypass validation
/////if your input is not in the correct formation (empty string for example )
///let filename = FileName(unchecked: "myfile.txt")
///
/////You can also pass in your own validation regex
///let file = try FileName("myfile.txt",validation: /\w+.txt/)
///```
public struct FileName : Sendable , Hashable , Equatable, Codable{
    
    public let fullname : String
    
    private let parts : [String]
    
    public var name : String{
        guard !parts.isEmpty else{
            return ""
        }
        return parts[0..<parts.count - 1].joined(separator: ".")
    }
    
    public var `extension` : String{
        parts.last ?? ""
    }
    
    public init(name fullname: String) throws {
        guard  fullname.wholeMatch(of: Self.validation) != nil else{
            throw FileNameError.invlaidFileName
        }
        self.parts = fullname.split(separator: ".").map(String.init)
        self.fullname = fullname
        
    }
    
    ///This initializer will by pass the filename validation, but can crash at runtime if your filename format is incorrect
    public init(unchecked value : String){
        self.fullname = value
        self.parts = value.split(separator: ".").map(String.init)
    }
    
}


extension FileName : ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = try! .init(name: value)
    }
    
    
}
public extension FileName {
    
    ///This initializer will by pass the filename validation
    static func unchecked(_ fullname: String) -> Self {
        .init(unchecked: fullname)
    }
    
    ///Creates a ".txt" file with your provided name
    static func txt(_ name: String) throws -> Self {
        if name.hasSuffix(".txt"){
            return try FileName(name: name)
        }
        
        return try FileName(name:"\(name).txt")
    }
    
}
