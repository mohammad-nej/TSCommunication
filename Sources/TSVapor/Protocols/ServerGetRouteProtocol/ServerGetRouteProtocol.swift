//
//  GetRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import Vapor
import TSShared


///For Get routes that only send json to client
public protocol ServerGetRouteProtocol : AnyHttpRoute ,FileTransferMethodable  where ClosureResponse == OutputData, OutputData : Content{
}

extension ServerGetRouteProtocol {
    
    ///We have to define on this type.
    static var transferMethod : FileTransferMethod { .default }
    
    static var method: HttpMethod { .GET }
    
}


