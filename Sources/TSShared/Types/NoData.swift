//
//  NoData.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

///A type that can be used as InputData or OutputData for routes that don't have either InputData or Output data
///

public struct NoData :  Codable , Sendable , Equatable , Hashable {
    public init(){}
    
    public static var empty : NoData { .init() }
}
