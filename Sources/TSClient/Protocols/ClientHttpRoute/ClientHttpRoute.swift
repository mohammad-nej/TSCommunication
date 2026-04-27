//
//  FileSendable.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/22/26.
//
import Foundation
import TSShared



///A route that can send a json payload to server and return a  json/response in return
///
///This should be your go to option for all HttpMethods except GET.
///
///if you want to send a GET request to server use ``ClientGetRouteProtocol`` instead.
///
///By conforming to this protocol you will get access to `send` function:
///```swift
///try await AddContactRoute
///     .send(contactDTO, config : .myConfig)
///```
public protocol ClientHttpRoute : HttpRoute, EncoderDecoder {
    
    
    associatedtype Coding : EncoderDecoder = DefaultCoding
    
    static func send<T:UpHttpClient>(_ data : InputData , parameters : [String], queryItems : [String : String] ,config : RequestConfig<T>) async throws -> (OutputData,URLResponse)
    
    static func send<T:UpHttpClient>(_ data : InputData, parameters : [String], queryItems : [URLQueryItem] ,config : RequestConfig<T>) async throws -> (OutputData,URLResponse)
    
    static var timeoutInterval : TimeInterval? { get }
}

public extension ClientHttpRoute {
    
    static var timeoutInterval : TimeInterval? { nil }
    
    static var contentType : ContentType { .json }
    
    static var encoder: JSONEncoder {
        Coding.encoder
    }
    static var decoder: JSONDecoder {
        Coding.decoder
    }
    
   
}
