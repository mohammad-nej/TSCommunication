//
//  StreamableServerRouteProtocol.swift
//  Whisper
//
//  Created by MohammavDev on 4/8/26.
//

import Vapor
import TSShared




///This protocol can be used for routes that need to upload a small payload to server
///
///By extending to your `FileUploadable` to this protocol:
///
///1. Your default http method will be set to `.POST`, you can override this value in your concrete type if you want
///
///2. You will get access to some helper functions like, `getFileAndInputData(from:Request,..)`
///
///Example :
///```swift
///extension UploadFileRoute : ServerFileUploadable {
///     static var closure : @Sendable (Vapor.Request) async throws -> MyRouteProtocolType.OutputData{
///         return { req in
///             //...
///         }
///     }
///}
///```
public protocol ServerFileUploadable: FileUploadable, AnyHttpRoute where InputData : Content , OutputData:Content , ClosureResponse == OutputData {}



