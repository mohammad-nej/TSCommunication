//
//  Untitled.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/29/26.
//

import Vapor
import TSShared

///Routes that receive a large file being streamed into them, should conform to this protocol.
///
///By conforming to this protocol you will have access to it's helpers for receiving your file in chunks , or even writing into disk directly
///```swift
/////in your route closure
///return { req in
/// //get file chunks
/// try await UserMovieUploadRoute.getFileChunk(from : req){ chunk in
///      //do your stuff
/// }
/// //or you can just write it to disk directly
/// try await UserMovieUploadRoute.writeFileToDisk(from: req, path : filepath )
///}
///```
public protocol ServerLargeFileUploadable :  LargeFileUploadable, AnyHttpRoute where  OutputData:Content , ClosureResponse == OutputData {}





