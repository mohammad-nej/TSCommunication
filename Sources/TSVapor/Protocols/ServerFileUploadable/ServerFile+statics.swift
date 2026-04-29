//
//  ServerFile+statics.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/27/26.
//

import Foundation
import TSShared
import Vapor
import NIOCore
public extension ServerFileUploadable{
    ///Extracts the inputData and file that was uploaded to server from the request
    ///
    ///If you have used `TSClient` package to upload your file to sever using `sendFile(metaData:InputData,..)`, you can get your Data and metaData sent with it
    ///using this function.
    ///
    ///Example:
    ///```swift
    /////on Client side
    ///try await MyUploadableRoute.send(metaData:"something",data :fileData,filename: "sample.txt")
    ///
    /////now on your route closure on sever side
    ///let (buffer,metaData) = try await MyUploadableRoute.getFileAndInputData(from : request)
    ///let data = Data(buffer: buffer)
    ///```
    static func getFileAndInputData(from request : Request, using decoder : JSONDecoder = JSONDecoder()) throws -> (ByteBuffer,InputData){
        
        let uploaded = try request.content.decode(_MetaData.self)
        
        guard Self.transferMethod != .stream else {
            throw Abort(.badRequest, reason: "Can't extract file data when using .stream transfer method")
        }
        
        let fileBuffer = uploaded.file.data
        let dto = try decoder.decode(
            InputData.self,
            from: Data(uploaded.metaData.utf8)
        )
        return (fileBuffer,dto)
    }
    
    
    ///Write the file that is sent within this request directly to disk
    static func writeFileToDisk(from request : Request, path : String ,using decoder : JSONDecoder ) async throws {
        let fileBuffer = try request.content.decode(_MetaData.self).file.data
        try await request.fileio.writeFile(fileBuffer, at: path)
    }
}
