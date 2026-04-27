//
//  HttpRoute+.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//


import TSShared
import VaporTestUtils
import TSVapor
import Vapor

public extension HttpRoute{
    
    ///Injects your InputData into the request content
    static func insert(_ input : Self.InputData, in  request :  inout TestingHTTPRequest, using encoder : (any ContentEncoder)? = nil) throws where Self.InputData : Content  {
        if let encoder{
            try request.content.encode(input, using: encoder)
        }
        try request.content.encode(input)
    }
}