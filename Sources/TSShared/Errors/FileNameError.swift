//
//  FileNameError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import Foundation


public enum FileNameError: Error, LocalizedError{
        case empty, noExtension, specialCharacter
    
    public var errorDescription: String? {
        switch self {
        case .empty:
            return "The file name is empty"
        case .noExtension:
            return "The file name does not contain an extension"
        case .specialCharacter:
            return "The file name contains a special character"
        }
    }
}
