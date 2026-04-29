//
//  ServerBig+statics.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//
import TSShared
import Foundation
import NIOCore
import Vapor
public extension ServerBigFileUploadable {
    
    
    ///Write the file that is sent within this request directly to disk
    ///
    ///This method will adapt depending on your routes `.transferMethod` variable.
    static func writeFileToDisk(from request : Request, path : String ,using decoder : JSONDecoder ) async throws {
        let fileIO = request.application.fileio
        let stream = request.body
        let handle = try NIOFileHandle(path: path, mode: .write, flags: .allowFileCreation())
        do{
            for try await chunk in stream {
                _ = fileIO.write(
                    fileHandle: handle,
                    buffer: chunk,
                    eventLoop: request.eventLoop)
            }
            
            try handle.close()
        }catch{
            try handle.close()
            throw error
        }

    }

    ///Reads a stream from client as an `AsyncSequence`, your provided closure will run upon receiving file chunks, on each chunk
    static func getFileChunk(from request : Request, _ action : (ByteBuffer) async throws -> Void) async throws {
        
        for try await chunk in request.body {
            try await action(chunk)
        }
        
    }

    
}
