//
//  FileUploadable.swift
//  PrivateMessanger
//
//  Created by MohammavDev on 4/22/26.
//

import Foundation
import TSShared



///For routes that use multipart to send their request
///
///This can be used by routes that send a small file with some meta data to server.
///
///This method will send the entire file in one request, while this is not a problem for smaller files, if you file
///is big consider using ``ClienBigFileUploadable`` instead
public protocol  ClientSmallFileUploadable : FileUploadable ,ClientHttpRoute{
    
    ///Responsible for Encoding/Decoding your data
    associatedtype Coding : EncoderDecoder = DefaultCodingConfig
    
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
