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
///is big consider using ``ClienBigFileUploadable`` instead
///
///By conforming to this protocol you will get access to `upload` function:
///```swift
///try await UploadTextFile
///             .upload(metaData: "test",
///                     data: fileData,
///                     filename : "config.txt",
///                     config: .myConfig)
///```
public protocol  ClientSmallFileUploadable : FileUploadable ,ClientHttpRoute{
    
    ///Responsible for Encoding/Decoding your data
    associatedtype Coding : EncoderDecoder = DefaultCoding
    
    static var timeoutInterval: TimeInterval { get }
    
    static func upload<T:UpHttpClient>(metaData : InputData? , data : Data,filename : FileName, parameters : [String], queryItems : [URLQueryItem]  ,config : RequestConfig<T> ) async throws -> (OutputData,URLResponse)
    
    static func upload<T:UpHttpClient>(metaData : InputData? , data : Data,filename : FileName, parameters : [String], queryItems : [String:String]   ,config : RequestConfig<T>) async throws -> (OutputData,URLResponse)
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
