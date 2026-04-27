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
 public protocol ServerFileUploadable: ServerRouteProtocol,FileUploadable {}



