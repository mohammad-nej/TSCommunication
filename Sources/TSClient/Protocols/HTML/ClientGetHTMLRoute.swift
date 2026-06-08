//
//  ClientGetHTMLRoute.swift
//  TSCommunication
//
//  Created by MohammavDev on 6/7/26.
//

import TSShared
import Foundation




public protocol ClientGetHTMLRoute : GetHTMLRoute {
    
    associatedtype Coding : EncoderDecoder = DefaultCoding
    
    static func get(parameters : [String], queryItems : [String : String],server : ServerConfiguration , client : any GETHttpClient, config : Configuration,modify : RequestModifier ) async throws -> ServerResponse<Self>
    
    static func get(parameters : [String],queryItems : [URLQueryItem],server : ServerConfiguration , client : any GETHttpClient, config : Configuration,modify : RequestModifier  ) async throws -> ServerResponse<Self>
    
    static var timeoutInterval : TimeInterval? { get }
    
    
}


public extension ClientGetHTMLRoute {
    static var timeoutInterval: TimeInterval? {
        nil
    }
    
    
}
