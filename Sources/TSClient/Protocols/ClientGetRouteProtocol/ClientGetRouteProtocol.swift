//
//  GetRouteProtocol.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/9/26.
//

import TSShared
import Foundation


///Route for Get request that doesn't have InputData at all
public protocol ClientGetRouteProtocol : GetHttpRoute {
    
    associatedtype Coding : EncoderDecoder = DefaultCodingConfig
    
    static func get<T:GETHttpClient>(parameters : [String], queryItems : [String : String], config : RequestConfig<T>  ) async throws -> (OutputData,URLResponse)
    
    static func get<T:GETHttpClient>(parameters : [String],queryItems : [URLQueryItem], config : RequestConfig<T> ) async throws -> (OutputData,URLResponse)
    
    static var timeoutInterval : TimeInterval? { get }
}


public extension ClientGetRouteProtocol {
    
    static var encoder: JSONEncoder {
        Coding.encoder
    }
    static var decoder: JSONDecoder {
        Coding.decoder
    }

    static var timeoutInterval : TimeInterval? { nil }
    
}
