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
///let data = try await DownloadImage.download(server : .server)
///                                     .asOutput
///```
public protocol ClientFileDownloadable : FileDownloadable , EncoderDecoder {
    
    
    static func download(parameters : [String], queryItems : [String : String],server: ServerConfiguration,
                         client: any GETHttpClient,
                         config : Configuration,
                         modify : RequestModifier ) async throws -> ServerResponse<Self>
    
    static func download(parameters : [String],queryItems : [URLQueryItem], server: ServerConfiguration,
                         client: any GETHttpClient,
                         config : Configuration,
                         modify : RequestModifier) async throws -> ServerResponse<Self>
    
    static var timeoutInterval : TimeInterval? { get }
    
}

public extension ClientFileDownloadable {
    
    
    static var timeoutInterval: TimeInterval? {
        150
    }
}
