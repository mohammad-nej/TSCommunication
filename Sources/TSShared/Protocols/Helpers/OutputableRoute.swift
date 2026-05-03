//
//  OutputableRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

public protocol OutputableRoute : HttpPathable {
    associatedtype OutputData : Codable
}


public protocol InputOutputableRoute : OutputableRoute {
    associatedtype InputData : Codable
    
}
