//
//  FileNameError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import Foundation


public enum FileNameError: Error, LocalizedError{
        case invlaidFileName
    
    
    public var errorDescription: String? {
        switch self {
        case .invlaidFileName:
            "File Name is invlaid"
        }
    }
}
