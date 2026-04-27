//
//  ClientBigFileUploadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/25/26.
//
import TSShared
import Foundation

///If you want to send a big file to server, conform to this protocol
///
///By conforming to this protocol you get access to `upload` functions that will let you stream a large file to your server
///
///```swift
///
/// try await MyBiGFileRoute
///     .upload(fileUrl:url,config:.myconfig)
///```
public protocol ClientBigFileUploadable :  GetHttpRoute{
    associatedtype Coding : EncoderDecoder = DefaultCoding
    static func upload<T:UploadHttpClient>(fileUrl: URL, parameters : [String],
                                           queryItems : [String:String] ,
                                           config: RequestConfig<T>
    ) async throws -> (OutputData,URLResponse)
    
    static func upload<T:UploadHttpClient>(fileUrl: URL, parameters : [String],
                                           queryItems : [URLQueryItem] ,
                                           config: RequestConfig<T>
    ) async throws -> (OutputData,URLResponse)
    
    
    static var timeoutInterval : TimeInterval { get }
}



protocol SnakeCodingGetHttp : ClientGetRouteProtocol where Coding == SnakeCaseCoding {}
