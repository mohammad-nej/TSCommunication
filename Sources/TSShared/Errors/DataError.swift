//
//  DataError.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import Foundation

public enum DataError: Error, LocalizedError {
    case emptyData
    
    public var errorDescription: String? {
        "Data your are trying to send is empty"
    }
}
