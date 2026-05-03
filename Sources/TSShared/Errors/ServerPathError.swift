//
//  ServerPathError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import Foundation


public enum ServerPathError : Error, LocalizedError{
    case invalidPath
    
    public var errorDescription: String? {
        switch self {
        case .invalidPath:
            return "The path is invalid"
        }
    }
}
