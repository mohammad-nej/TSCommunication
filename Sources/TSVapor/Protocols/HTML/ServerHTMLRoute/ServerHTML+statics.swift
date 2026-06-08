//
//  ServerHTML+statics.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/29/26.
//

import Foundation
import Vapor
import TSShared




public extension ServerHTMLRoute {
    
    ///Sends back your html response to client
    static func send(html raw : String,
                     headers : HTTPHeaders = ["Content-Type": "text/html; charset=utf-8"],
                     status : HTTPResponseStatus = .ok) throws -> Response {
        
        return   .init(status: status, headers: headers  ,body: .init(string: raw))
    }
}
