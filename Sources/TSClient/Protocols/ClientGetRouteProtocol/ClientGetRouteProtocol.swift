//
//  GetRouteProtocol.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/9/26.
//

import TSShared
import Foundation


///A route that doesn't upload any data to server, e.g. GET request
///
///By conforming to this protocol you can download data from server using get function
///```swift
///let (result,response) =
/// try await MyGetRoute
///         .get(paramters:[],server:.myServer)
///```
public protocol ClientGetRouteProtocol : GetHttpRoute, EncoderDecoder {
    
    associatedtype Coding : EncoderDecoder = DefaultCoding
    
    static func get(parameters : [String], queryItems : [String : String],server : ServerConfiguration , client : any GETHttpClient, config : Configuration,modify : RequestModifier ) async throws -> ServerResponse<Self>
    
    static func get(parameters : [String],queryItems : [URLQueryItem],server : ServerConfiguration , client : any GETHttpClient, config : Configuration,modify : RequestModifier  ) async throws -> ServerResponse<Self>
    
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
