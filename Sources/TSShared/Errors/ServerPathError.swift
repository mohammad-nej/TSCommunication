//
//  ServerPathError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import Foundation


public enum ServerPathError : Error, LocalizedError{
    case commaIsNotValid, partCanNotContainSlash, pathIsEmpty,invalidPath
    
    public var errorDescription: String? {
        switch self {
        case .commaIsNotValid:
            return "The comma is not valid in a path"
        case .partCanNotContainSlash:
            return "A part of the path can not contain a slash"
        case .pathIsEmpty:
            return "The path is empty"
        case .invalidPath:
            return "The path is invalid"
        }
    }
}
