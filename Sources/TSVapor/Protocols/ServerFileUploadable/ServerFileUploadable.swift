//
//  StreamableServerHttpRoute.swift
//  Whisper
//
//  Created by MohammavDev on 4/8/26.
//

import Vapor
import TSShared




///This protocol can be used for routes that need to upload a small payload to server
///
///By extending to your `FileUploadable` to this protocol, you can extract your uploaded file and it's metaData
///with ease.
///```swift
///extension UploadFileRoute : ServerFileUploadable {
///     static var closure : @Sendable (Vapor.Request) async throws -> MyRouteProtocolType.OutputData{
///         return { req in
///            let (fileBuffer,input) = try UploadFileRoute.getFileAndInputData(from: req)
///            //fileBuffer ->      ByteBuffer    your file
///            //input      ->      InputData     input data uploaded
///         }
///     }
///}
///```
public protocol ServerFileUploadable: FileUploadable, AnyHttpRoute where InputData : Content , OutputData:Content , ClosureResponse == OutputData {}



