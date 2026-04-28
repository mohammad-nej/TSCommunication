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
///let filename : Filename = try Filename("myfile.txt")
///
/////This initializer will bypass validation, might crash at runtime
/////if your input is not in the correct formation (empty string for example )
///let filename = Filename(withUnsafeName: "myfile.txt)
///```
public struct FileName : Sendable , Hashable , Equatable, Codable{
    
    
    
    
    
    public let fullname : String
    
    private let parts : [String]
    
    public var name : String{
        parts[0..<parts.count - 1].joined(separator: ".")
    }
    
    public var `extension` : String{
        parts.last!
    }
    
    public init(name fullname: String) throws {
        self.parts = try Self.validate(fullname)
        self.fullname = fullname
        
    }
    
    ///This initializer will by pass the filename validation, but can crash at runtime if your filename format is incorrect
    public init(withUnsafeName value : String){
        self.fullname = value
        self.parts = value.split(separator: ".").map(String.init)
    }
    
}

extension FileName {
    static func validate(_ name : String) throws -> [String] {
        
        guard name.isEmpty == false else {
            throw FileNameError.empty
        }
        
        let specialCharacters = ["\\", "/", ":", "*", "?", "\"", "<", ">", "|"]
        
        let seperated = name.split(separator: ".")
        
        if seperated.count == 1{
            throw FileNameError.noExtension
        }
        
        //Checking for special characters
        for character in specialCharacters {
            if name.contains(character) {
                throw FileNameError.specialCharacter
            }
        }
        return seperated.map(String.init)
    }
}

extension FileName : ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self = try! .init(name: value)
    }
    
    
}
public extension FileName {
    
    ///This initializer will by pass the filename validation, but can crash at runtime if your filename format is incorrect
    static func `unsafe`(_ fullname: String) -> Self {
        .init(withUnsafeName: fullname)
    }
    
    ///Creates a ".txt" file with your provided name
    static func txt(_ name: String) throws -> Self {
        try .init(name:"\(name).txt")
    }
    
}
