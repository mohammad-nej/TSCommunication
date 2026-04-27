//
//  GetRouteProtocol.swift
//  TSShared
//
//  Created by MohammavDev on 4/22/26.
//


///A route that can only receive json from server.
public protocol GetHttpRoute: IdentifiableRoute{
    associatedtype OutputData : Codable
           
    static var contentType : ContentType { get }
    static var path: ServerPath { get }
    static var method : HttpMethod { get }
    
    init()
}

public extension GetHttpRoute {
    static  var method: HttpMethod { .get }
    static var contentType: ContentType { .json }
}
