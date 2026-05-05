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
let response = try await MyHttpRoute
                                    .send(inputJson,
                                        parameters:["some"],
                                        queryItems: ["name" : "jackson"],
                                        config:.server)
```
The same process can be done for other routes in your server :
```swift
    extension MyGetHttpRoute : ClientGetRouteProtocol {}
    extension MySmallFileUploadable : ClientSmallFileUploadable {} 
    extension MyLargeFileUploadable : ClientLargeFileUploadable {}  
    extension MyFileDownloadable : ClientFileDownloadable {}
```

## RequestConfig:
This type contains all the information needed to connect to a server, the ``HttpClient`` used for sending data and ``URLCreationMode`` options used for your route.

```swift
let server = ServerConfiguration(method:.http,domain: "127.0.0.1", port: 8080)
let requestConfig = RequestConfig(server:server, client:.shared,
                                    delegate: myUrlSessionDelegate ,mode:.safe)
```
it's highly recommended to extend ``RequestConfig`` and create an static instance of it for yourself, cause all helper functions provided in this target need an instance of this type in-order to connect to server.
```swift
extension RequestConfig{
    static var myServer : RequestConfig { 
        //..
    }   
}
```
- Note:
``RequestConfig`` take a type conforming to ``HttpClient`` as it's `client` parameter. This target have already extended ``URLSession`` to act as an ``HttpClient``, meaning that you can insert your own ``URLSession`` object and even it's delegate to your ``RequestConfig``.

## ServerResponse
All helper functions in this package return a ``ServerResponse`` upon completion. This type is just a wrapper around standard `(Data,URLSession)` which is returned from URLSession functions.

```swift
let response = try await DownloadRoute.download(config:.server) // -> server response
let fileData = try response.asOutput //return the output of this route if possible
let serverError = try response.asServerError //return the server error if possible
let result = try response.asResult // Result<OutputData,Failure>
let tuple = response.asTuple // the original (Data,URLSession)
```

## Mocking:
Mocking is crucial for testing your client app. You can mock your server using `RequestConfig.httpClient` parameter.
``HttpClient`` can be mocked to send your request to a mock object instead.

Five different mock servers ``MockHttpServer``, ``MockDownloadServer`` ,``MockGetServer``, ``MockUpServer``, ``MockFileServer`` are already provided in this target. You can easily create a mock config for your route:
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
let response = try await MyPostRoute.send("some data",
                                            config: MyPostRoute.mockConfig(always:true))
```
You can also mock server error :
```swift
let error = VaporError(error:true, reason:"This is a test")
let response = try await MyPostRoute.send("some data",
                                            config: MyPostRoute.mockConfig(throws:error))
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



