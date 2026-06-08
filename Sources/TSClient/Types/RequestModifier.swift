//
//  RequestModifier.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/7/26.
//
import Foundation
#if os(Linux)
import FoundationNetworking
#endif

///A closure that can modify a request
public typealias RequestModifier = (inout URLRequest) throws -> Void
