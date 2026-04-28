//
//  RegisterationError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/28/26.
//

import Foundation
import TSShared


public enum RegisterationError : Error, LocalizedError {
    case moreThanOnce
    
    public var errorDescription: String? {
        "Routes registration function should run exactly once per server launch."
    }
}
