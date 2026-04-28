//
//  WithByPass.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//
@testable import TSVapor
import Foundation

///Lets by pass internal lock mechanism
func withByPassLock(_ closure : () async throws -> ()) async throws{
    RouteRegistrar.byPassLockForTest = true
    try await closure()
    RouteRegistrar.byPassLockForTest = false
    
}
