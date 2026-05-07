//
//  FileUploadable.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/22/26.
//

import Foundation
import TSShared



///A routes that use multipart to send its requests
///
///This can be used by routes that send a small file with some meta data to server.
///
///This protocol will send the entire file in **one** multipart request, while this is not a problem for smaller files, if you file
///is big consider using ``ClientLargeFileUploadable`` instead
///
///By conforming to this protocol you will get access to `upload` function:
///```swift
///try await UploadTextFile
///             .upload(metaData: "test",
///                     data: fileData,
///                     filename : "config.txt",
///                     server:.myServer)
///```
public protocol  ClientSmallFileUploadable : FileUploadable , EncoderDecoder {
    
    ///Responsible for Encoding/Decoding your data
    associatedtype Coding : EncoderDecoder = DefaultCoding
    
    static var timeoutInterval: TimeInterval { get }
    
    static func upload(metaData : InputData? , data : Data,filename : FileName, parameters : [String], queryItems : [URLQueryItem]  , server: ServerConfiguration,
                                       client: any UpHttpClient,
                                       config : Configuration,
                                       modify : RequestModifier ) async throws -> ServerResponse<Self>
    
    static func upload(metaData : InputData? , data : Data,filename : FileName, parameters : [String], queryItems : [String:String] , server: ServerConfiguration,
                       client: any UpHttpClient,
                       config : Configuration,
                       modify : RequestModifier ) async throws -> ServerResponse<Self>
}

public extension ClientHttpRoute where OutputData : Sendable {
    static func constant(_ value : OutputData) -> MockUpServer<OutputData>{
        return MockUpServer(for: Self.self ,always: value)
    }
}

public extension ClientSmallFileUploadable  {
    
    
    static var encoder: JSONEncoder {
        Coding.encoder
    }
    static var decoder: JSONDecoder {
        Coding.decoder
    }
    
    
    static var timeoutInterval : TimeInterval { 150 }
    static var contentType: ContentType { .multipartFormData }
    
    
}
