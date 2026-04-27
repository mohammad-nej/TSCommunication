# ``TSClient``

Make communicating with server easier

## Overview

Now that we have all our routes setup in our shared package using `TSShared`, we can get access to 
helper functions by simply conforming to Client-side protocols

Just like in `TSShared`, in here we also have 4 main protocols:
## Extend your routes

By just extending your route to it's related protocol you will get access to helper functions that it provides.
assuming that `MyHttpRoute` was defined as `HttpRoute` on shared package :
```swift
extension MyHttpRoute : ClientHttpRoute {} //Thats it! 
```
and now we can simply send data to sever in our app:
```swift
let (result,response) = try await MyHttpRoute
                                    .send(inputJson,
                                        parameters:["some"],
                                        queryItems: ["name" : "jackson"],
                                        config:.server)
```
the same process can be done for other routes in your server :
```swift
    extension MyGetHttpRoute : ClientGetRouteProtocol {}
    extension MyFileUploadable : ClientSmallFileUploadable {} //NOTICE
    extension MyFileUploadable2 : ClientBigFileUploadable {}  //NOTICE
    extension MyFileDownloadable : ClientGetRouteProtocol {}
```
#### Notice:
Routes that conform to `FileUploadable` in `TSShared`, can be extended to both ``ClientSmallFileUploadable`` or ``ClientBigFileUploadable``.
As their names suggests, each use a different approach to send your file. Small one, uses MultiPart request to send your file along side an optional Json payload, the big one streams a file to server directly from file URL, which is way more efficient for  large files.
## RequestConfig:
This type contains all the information needed to connect to a server, the ``HttpClient`` used for sending data and ``URLCreationMode`` options used for your route.

```swift
let server = ServerConfiguration(method:.http,domain: "127.0.0.1", port: 8080)
let requestConfig = RequestConfig(server:server, client:.shared,
                                    delegate: myUrlSessionDelegate ,mode:.safe)
```
it's highly recommended to extend ``RequestConfig`` and create an instance of it for yourself, cause all helper functions provided in this target need an instance of this type in-order to connect to server.
```swift
extension RequestConfig{
    static var myServer : RequestConfig { 
        //..
    }   
}
```
#### Note:
``RequestConfig`` take a type conforming to ``HttpClient`` as it's `client` parameter. This target have already extended ``URLSession`` to act as an ``HttpClient``, meaning that you can insert your own ``URLSession`` object and even it's delegate to your ``RequestConfig``.
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
2 - Create a new  protocol to shadow client side protocols (like ``ClientGetRouteProtocol``)
```swift
protocol SnakeCodingGetRoute : ClientGetRouteProtocol 
            where Coding == SnakeCaseCoding {}
```
3 - Now extend all your routes to your new protocols instead
```swift
extension MyGetRoute : SnakeCodingGetHttp {}
```


## Mocking:
Mocking is crucial for testing your client app. You can mock your server using `RequestConfig.httpClient` parameter.
``HttpClient`` can be mocked to send your request to a mock object instead.

Four different mock servers ``MockHttpServer``, ``MockGetServer``, ``MockUpServer``, ``MockFileServer`` are already provided in this target. You can easily create a mock config for your route:
```swift
//Creats a mock server that always returns hello
let mock = MockGetServer(MyGetRoute.self){ request in
    return ("Received",URLSession())
}
let mockConfig = mock.config 

try await MyGetRoute.get(parameters:[],config : mockConfig)
```
Moreover than that, all Client side protocols provide an appropriate mockConfig depending on their type:
```swift
let (value,response) = try await MyPostRoute.send("some data",
                                            config: MyPostRoute.mockConfig(always:true))
```
### Pro tip:
Since ``MockHttpServer`` input and output is `Data`, it can be used as `HttpClient` for all routes. This means that, not only it can be used as a mock server, but also it can be your **Offline Server**. You can pass it to your routes `config` parameter while your server/client is offline:
```swift
let offlineServer = MockHttpServer{data , req in
    //save this request in local db, to be done later
    //...
    return (Data(),URLResponse())
}downloadData : { request in
    //save it a queue for later?
    //...
    return (Data(),URLResponse())
}uploadFile: { url , request
    //save in a queue or something ? 
    //...
    return (Data(),URLResponse())
}

//Then in your app you can check
MyRoute.get(config: isOnline ? realServer : offlineServer.config)
```
## Topics


### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
