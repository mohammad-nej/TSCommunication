//
//  URLConversionError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//


import Foundation


public enum URLConversionError: Error , LocalizedError {
    case insufficientAmountOfParameters, extraAmountOfParameters
    public var errorDescription: String? {
        switch self {
        case .extraAmountOfParameters:
            "Extra amount of parameters"
        case .insufficientAmountOfParameters:
            "Insufficient amount of parameters"
        }
    }
}
