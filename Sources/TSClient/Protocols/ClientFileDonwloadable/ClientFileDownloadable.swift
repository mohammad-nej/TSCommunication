//
//  ClientFileDownloadable.swift
//  TSCommunication
//
//  Created by MohammavDev on 5/1/26.
//

import TSShared
import Foundation


///For routs that lets client download a file from server
///
///You can download your files from server using ``download(parameters:queryItems:config:)-(_,[URLQueryItem],_)`` function
///```swift
///let data = try await DownloadImage.download(config : .server)
///                                     .asOutput
///```
public protocol ClientFileDownloadable : FileDownloadable , EncoderDecoder {
    
    
    static func download<T:GETHttpClient>(parameters : [String], queryItems : [String : String], config : RequestConfig<T>  ) async throws -> ServerResponse<Self>
    
    static func download<T:GETHttpClient>(parameters : [String],queryItems : [URLQueryItem], config : RequestConfig<T> ) async throws -> ServerResponse<Self>
    
    static var timeoutInterval : TimeInterval? { get }
    
}

public extension ClientFileDownloadable {
    
    
    static var timeoutInterval: TimeInterval? {
        150
    }
}
