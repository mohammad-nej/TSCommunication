//
//  GetRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import Vapor
import TSShared


///This can be used to create GET request

public protocol ServerGetRouteProtocol : GetHttpRoute,InnerMiddewareContainer,BuildableBlock,VaporRespondable, FileTransferMethodable  where ClosureResponse == OutputData{
}

extension ServerGetRouteProtocol {
    
    ///We have to define on this type.
    static var transferMethod : FileTransferMethod { .default }
    
    static var method: HttpMethod { .get }
    
}


extension ServerGetRouteProtocol{
    public var innerMiddleware: InnerMiddleWareBuilder{
        var builder: InnerMiddleWareBuilder = .init()
        builder.routes = [Self.self]
        return builder
    }
    
    public var routes: [any Groupable.Type] { [Self.self] }
}



