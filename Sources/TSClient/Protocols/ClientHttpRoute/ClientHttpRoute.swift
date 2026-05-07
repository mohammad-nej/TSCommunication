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
///     .send(contactDTO, server:.myServer)
///```
public protocol ClientHttpRoute : HttpRoute {
    
    
    static func send(_ data : InputData , parameters : [String], queryItems : [String : String]       , server: ServerConfiguration,
                     client: any UpHttpClient ,
                     config : Configuration ,
                     modify : RequestModifier ) async throws -> ServerResponse<Self>
    
    static func send(_ data : InputData, parameters : [String], queryItems : [URLQueryItem]       , server: ServerConfiguration,
                                     client: any UpHttpClient,
                                     config : Configuration ,
                                     modify : RequestModifier) async throws -> ServerResponse<Self>
    
    static var timeoutInterval : TimeInterval? { get }
}

public extension ClientHttpRoute {
    
    static var timeoutInterval : TimeInterval? { nil }
    
    static var contentType : ContentType { .json }
    
  
    
   
}
