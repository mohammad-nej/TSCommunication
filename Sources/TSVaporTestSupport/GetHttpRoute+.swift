//
//  RouteProtocol+.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/23/26.
//

import TSShared
import VaporTestUtils
import TSVapor
import Vapor

public extension GetHttpRoute {
    
    ///Converts vapor response to your output and pass it out
    static func output(from response : TestingHTTPResponse, using decoder : (any ContentDecoder)? = nil) throws -> Self.OutputData {
        if let decoder{
            return try response.content.decode(OutputData.self, using: decoder)
        }
        return try response.content.decode(OutputData.self)
    }
}

public extension HttpRoute{
    
    ///Injects your InputData into the request content
    static func insert(_ input : Self.InputData, in  request :  inout TestingHTTPRequest, using encoder : (any ContentEncoder)? = nil) throws where Self.InputData : Content  {
        if let encoder{
            try request.content.encode(input, using: encoder)
        }
        try request.content.encode(input)
    }
}
