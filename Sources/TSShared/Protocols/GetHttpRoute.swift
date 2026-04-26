//
//  GetRouteProtocol.swift
//  TSShared
//
//  Created by MohammavDev on 4/22/26.
//

public protocol GetHttpRoute{
    associatedtype OutputData : Codable
           
    static var contentType : ContentType { get }
    static var path: ServerPath { get }
    static var method : HttpMethod { get }
}

public extension GetHttpRoute {
    static  var method: HttpMethod { .get }
    static var contentType: ContentType { .json }
}
