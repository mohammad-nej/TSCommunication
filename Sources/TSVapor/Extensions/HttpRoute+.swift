//
//  RouteProtocol+.swift
//  Whisper
//
//  Created by MohammavDev on 4/6/26.
//

import TSShared
import Vapor


public extension HttpRoute{
    
    ///Decoded input of this request
    static func decodeInput(in request : Request, using decoder : (any ContentDecoder)? = nil) throws -> InputData{
        if let decoder{
            return try request.content.decode(InputData.self, using: decoder)
        }
        return try request.content.decode(InputData.self)
    }
}



