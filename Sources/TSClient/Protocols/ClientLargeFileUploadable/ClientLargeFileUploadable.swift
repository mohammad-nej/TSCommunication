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
///     .upload(fileUrl:url,server:.myServer)
///```
public protocol ClientLargeFileUploadable :  LargeFileUploadable, EncoderDecoder{
    associatedtype Coding : EncoderDecoder = DefaultCoding
    static func upload(fileUrl: URL,
                       parameters : [String],
                       queryItems : [String:String] ,
                       server: ServerConfiguration,
                       client: any UploadHttpClient,
                       config : Configuration,
                       modify : RequestModifier
    ) async throws -> ServerResponse<Self>
    
    static func upload(
        fileUrl: URL,
        parameters : [String],
        queryItems : [URLQueryItem] ,
        server: ServerConfiguration,
        client: any UploadHttpClient,
        config : Configuration,
        modify : RequestModifier
                       
    ) async throws -> ServerResponse<Self>
    
    
    static var timeoutInterval : TimeInterval { get }
}


