//
//  GetRouteProtocol.swift
//  TSShared
//
//  Created by MohammavDev on 4/22/26.
//


///A route that can only receive data from server.
public protocol GetHttpRoute: OutputableRoute{}

public extension GetHttpRoute {
    static  var method: HttpMethod { .GET }
    
}
