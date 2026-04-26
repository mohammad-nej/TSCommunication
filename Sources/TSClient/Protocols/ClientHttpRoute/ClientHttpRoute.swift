//
//  FileSendable.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/22/26.
//
import Foundation
import TSShared



///Basic route that can send a json payload to server and return a  json/response in return
///
///This should be your go to option for all HttpMethods except GET.
///
///if you want to send a GET request to server use ``ClientGetRouteProtocol`` instead.
///
///assuming that you have an HttpRoute defined on your shared target, you can simply extend your route this protocol
///```swift
///extension UploadUserDataRoute : ClientHttpRoute {}
///```
public protocol ClientHttpRoute : HttpRoute, EncoderDecoder {
    
    
    associatedtype Coding : EncoderDecoder = DefaultCodingConfig
    
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
