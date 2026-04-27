//
//  GetRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import Vapor
import TSShared


///This can be used to create GET request
///
///This protocol just sets your InputData to `NoData`, since GET request can't have any content
public protocol ServerGetRouteProtocol : GetHttpRoute,VaporRespondable, FileTransferMethodable  where ClosureResponse == OutputData{
}

extension ServerGetRouteProtocol {
    
    ///We have to define on this type.
    static var transferMethod : FileTransferMethod { .default }

}

public extension ServerGetRouteProtocol {
    
    static var method: HttpMethod { .get }
}
