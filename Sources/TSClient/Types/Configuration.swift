//
//  Configuration.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/7/26.
//

import Foundation
import TSShared
#if os(Linux)
import FoundationNetworking
#endif


///Holds all configurations of a request
public struct Configuration : Sendable{
    
    public var urlCheckMode : URLCreationMode = .checked
    public var delegate : (any URLSessionTaskDelegate)? = nil
    
    public init(urlCheckMode: URLCreationMode, delegate: (any URLSessionTaskDelegate)? = nil) {
        self.urlCheckMode = urlCheckMode
        self.delegate = delegate
    }
    
    ///urlCheckMode = true , delegate = nil
    public static let `default` = Configuration(urlCheckMode: .checked, delegate: nil)
}
