//
//  ServerGetHTMLRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 6/7/26.
//

import TSShared
import Vapor


///A GET route that can send html back to clients
public protocol ServerGetHTMLRoute : ServerGetRouteProtocol where OutputData == HTML {}


public extension ServerGetHTMLRoute {
    
    ///Sends back your html response to client
    static func send(html raw : String,
                     headers : HTTPHeaders = ["Content-Type": "text/html; charset=utf-8"],
                     status : HTTPResponseStatus = .ok) throws -> Response {
        
        return   .init(status: status, headers: headers  ,body: .init(string: raw))
    }
}
