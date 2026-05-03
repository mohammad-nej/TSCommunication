# ``TSShared``

Contains your routes

## Overview

This target contains protocols that lets you define your routes. By defining  your routes in here, both
server and client app can have access to them in a type- safe manner.

## Details

This packages has 6 main protocols, each route should conform to 1 one of them depending on your needs:

@TabNavigator{
    @Tab("HttpRoute"){
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
            
            static let method: TSShared.HttpMethod = .POST
            
            static let contentType: ContentType = .json
            
        }
        ```
        note that everything is defined as *static* and this is intentional cause neither instantiating nor altering a route doesn't mean anything.

    }
    
    @Tab("GetHttpRoute"){
        This is just like ``HttpRoute``, but it doesn't have `InputData` cause a GET request doesn't send anything to server
        ```swift
        struct MySampleRoute : GetHttpRoute {
            
            typealias OutputData = String
            
            static let path: TSShared.ServerPath = "user"
            
            static let contentType: ContentType = .json
        }
        ```

    }
    @Tab("FileUploadable"){
        This should be used for routes that expect user to upload a small file to server. This protocol use MultiPart to send your file in a single request alongs side with a json payload. This should only be used file you are sending small. For larger files conform to ``LargeFileUploadable`` instead.        
        ```swift
        struct SampleFileUploadable : FileUploadable {
            typealias InputData = String
            
            typealias OutputData = String
            
            static var path: TSShared.ServerPath { "user" }
            
            
        }
        ```
    }
    
    @Tab("LargeFileUploadable"){
        If you want to upload a large file to server, this should be your go to option. This route will let you stream your file from client to server. 
        This route doesn't have an InputData cause it will stream a file directly from URL to server.
        ```swift
        struct SampleLargeFile : LargeFileUploadable {
            typealias OutputData = UUID
            static var path: TSShared.ServerPath { "some/large/path"}
        }
        ```
    }
    
    @Tab("FileDownloadable"){
        If you route is going to let client download a file from server, you should conform to this protocol. 
        ```swift
        struct DownloadMovie : FileDownloadable {
            static var path: TSShared.ServerPath { "downloadFile/:id" }
        }

        ```
        This protocol doesn't have an `InputData` and it's `OutputData` is always `Data`.
    }
    @Tab("WebSocketRoute"){
        If you want to open a WebSocket to your route, you have to conform to this protocol.
        ```swift
        struct MyWebSocketRoute : WebSocketRoute {
            static var path: TSShared.ServerPath { "webSocket" }
        }
        ```
    }
}
## Encoding/Decoding:
Encoding and Decoding json is an important part of every app that wants to communicate with a server. By default, all client side protocols use basic `JSONDecoder`/`JSONEncoder` as their encoder/decoder.

You can override this behavior by setting `encoder`/`decoder` static variables on your route
```swift
extension EchoRoute {
    static var encoder : JSONEncoder { 
        //...
        return myEncoder
    }

    static var decoder : JSONEncoder { 
        //...
        return myEncoder
    }
}
```
If you want to change decoder/encoder of all your routes at once, you have to take these steps:

 1 - Create a type conforming to EncoderDecoder protocol:
```swift

public struct SnakeCaseCoding : EncoderDecoder, Sendable   {
    public static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    public static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
```
2 - Create a new  protocol to shadow  main protocols (like ``GetHttpRoute``)
```swift
protocol SnakeCaseGetHttpRoute : GetHttpRoute
            where Coding == SnakeCaseCoding {}
```
3 - Now extend all your routes to your new protocols instead
```swift
extension MyGetRoute : SnakeCodingGetHttpRoute {}
```
## Server-side Error:
All protocols in this package also supports handling errors emitted by server. 

All main HTTP protocols conform to ``Failable`` protocol. this protocol lets us define a type conforming to ``ServerError`` for your route(s) and also provide a `JSONDecoder`/`JSONEncoder` for decoding/encoding errors.

By default, ``VaporError`` is set to be the default error type for ``Failable`` and ``DefaultConfig``
If you want to use a different type for your error on your route :
```swift
public struct MyRoute: GetHttpRoute{
    Failure = MyServerError
    FailureCoder = SnakeCaseCoding
}
```
this protocol also introduces an ``EncoderDecoder`` type for encoding/decoding errors, which can be overridden by setting ``Failable/failureEncoder`` and ``Failable/failureDecoder`` on your chosen type.
## ServerPath: 
As you might have noticed a type called ``ServerPath`` is used to receive the path of your route, make sure to check it'd documentation for more info

## Topics


