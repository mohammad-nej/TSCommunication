# ``TSShared``

Contains your routes

## Overview

This target contains protocols that lets you define your routes. By defining  your routes in here, both
server and client app can have access to them in a type- safe manner.

## Details

This packages has 4 main protocols, each route should conform to 1 one of them depending on your needs:

### HttpRoute protocol:

This is suitable for routes that user needs to send a json payload into them. like all POST routes for example.
This protocol has `InputData` and `OutputData` associated types which indicates the input/output of your route.
both `InputData` and `OutputData` are required to be `Codable`.
This is the definition of this protocol:

```swift
public protocol HttpRoute: Sendable {
    associatedtype InputData : Codable
    associatedtype OutputData : Codable
           
    static var contentType : ContentType { get }
    static var path: ServerPath { get }
    static var method : HttpMethod { get }
}
```

conforming to this protocol is easy:

```swift
struct MySampleRoute : HttpRoute {
    typealias InputData = String
    
    typealias OutputData = String
    
    static let path: TSShared.ServerPath = "user"
    
    static let method: TSShared.HttpMethod = .post
    
    static let contentType: ContentType = .json
    
}
```
note that everything is defined as *static* and this is intentional cause neither instantiating nor altering a route doesn't mean anything.

### GetHttpRoute protocol:

This is just like ``HttpRoute``, but it doesn't have `InputData` cause a GET request doesn't send anything to server
```swift
struct MySampleRoute : GetHttpRoute {
    
    typealias OutputData = String
    
    static let path: TSShared.ServerPath = "user"
    
    static let contentType: ContentType = .json
}
```

### FileUploadable protocol:

This should be used for routes that expect user to upload a large file to server. Requirements of this protocol is 
similar to ``HttpRoute``, however by conforming to this protocol you will get access to it's related helper functions on `TSClient` and `TSVapor` packages.

### FileDownloadable

This should be used for routes that expect user to download a large file from server. Requirements of this protocol is 
similar to ``GetHttpRoute``, however by conforming to this protocol you will get access to it's related helper functions on `TSClient` and `TSVapor` packages.


### One more thing: 
As you might have noticed a type called ``ServerPath`` is used to receive the path of your route, make sure that you check it's documentation.

## Topics


