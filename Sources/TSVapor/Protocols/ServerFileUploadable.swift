//
//  StreamableServerRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/8/26.
//

import Vapor
import TSShared
import NIOCore



///This protocol can be used for routes that need to upload a large payload to server
///
///By extending to your `RouteProtocol` to this protocol:
///
///1.Your default http method will be set to `.post`, you can override this value in your concrete type if you want
///
///2. You will get access to some helper functions like, `getFileAndInputData(from:Request,..)`
///
///Example :
///```swift
///extension UploadFileRoute : UploadableServerRoute {}
///```
 public protocol ServerFileUploadable: ServerRouteProtocol,FileUploadable ,
                                                FileTransferMethodable ,
                                                AddableRoute,
                                                VaporRespondable {}

public extension ServerFileUploadable {
    
    //Default is set to post , you can override it by defining a value in your concrete type
    static var method: HttpMethod { .post }
    
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
    
    ///Reads a stream from client as an `AsyncSequence`, your provided closure will run upon receiving file chunks, on each chunk
    static func getFileChunk(from request : Request, _ action : (ByteBuffer) async throws -> Void) async throws {
        
        for try await chunk in request.body {
            try await action(chunk)
        }
        
    }
    
    static func writeFileToDisk(from request : Request, path : String ,using decoder : JSONDecoder ) async throws {
        
        switch Self.transferMethod {
        case .stream:
            let fileIO = request.application.fileio
            let stream = request.body
              let handle = try NIOFileHandle(path: path, mode: .write, flags: .allowFileCreation())

              for try await chunk in stream {
                fileIO.write(
                    fileHandle: handle,
                      buffer: chunk,
                      eventLoop: request.eventLoop
                  )
              }

              try handle.close()
        case .collect(_):
            fallthrough
        case .default:
            let fileBuffer = try request.content.decode(_MetaData.self).file.data
            try await request.fileio.writeFile(fileBuffer, at: path)
        }
        
    }
        
}

public extension ServerFileUploadable {
    static var transferMethod: FileTransferMethod { .collect(.mb(10)) }
}

