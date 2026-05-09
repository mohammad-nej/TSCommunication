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
                                        server:.server)
```
The same process can be done for other routes in your server :
```swift
    extension MyGetHttpRoute : ClientGetRouteProtocol {}
    extension MySmallFileUploadable : ClientSmallFileUploadable {} 
    extension MyLargeFileUploadable : ClientLargeFileUploadable {}  
    extension MyFileDownloadable : ClientFileDownloadable {}
```

## Request Customization:
All helper functions in this target, provides so many customizations to your requests.
- You can use `client` parameter to inject your own instance of ``URLSession``, otherwise `URLSession.shared` instance will be used.
- `config` parameter can be used to pass in a `URLSessionTaskDelegate` if you want.
- `modify` closure will let you customize the request object, depending on your needs.

```swift
var mySession = URLSession()
//setup your own url session
//...
var config = Configuration(delegate:MySessionDelegate())

let result = try await MyDownloadRoute.get(parameters:[],server:.myServer, client: mySession, config: config){ request in 
    //add your custom headers, ...
}.asOutput
```
it's highly recommended to extend ``ServerConfiguration`` and create an static instance of it for yourself, cause all helper functions provided in this target need an instance of this type in-order to connect to server.
```swift
extension ServerConfiguration{
    static var myServer : ServerConfiguration { 
        //..
    }   
}
```
## Configuration
All helper functions provided with this target has a `config` parameter which takes an instance of ``Configuration`` as input. This type has 2 properties:
- urlCheckMode:
By default, when creating a request, amount of parameters that you send in a request is checked to match the amount of parameters needed by the server. 

You can turn off this behavior by setting ``Configuration/urlCheckMode`` to `.unchecked`
- delegate:
This is an instance of `URLSessionTaskDelegate`, which can be use to pass in a delegate to your `URLSession`, default value is `nil`

## ServerResponse
All helper functions in this package return a ``ServerResponse`` upon completion. This type is just a wrapper around standard `(Data,URLSession)` which is returned from URLSession functions.

```swift
let response = try await DownloadRoute.download(server:.server) // -> server response
let fileData = try response.asOutput //return the output of this route if possible
let serverError = try response.asServerError //return the server error if possible
let result = try response.asResult // Result<OutputData,Failure>
let tuple = response.asTuple // the original (Data,URLSession)
```

## Mocking:
Mocking is crucial for testing your client app. You can mock your server using `client` parameter.
``HttpClient`` can be mocked to send your request to a mock object instead.

Five different mock servers ``MockHttpServer``, ``MockDownloadServer`` ,``MockGetServer``, ``MockUpServer``, ``MockFileServer`` are already provided in this target. You can easily create a mock config for your route:
```swift
//Create a mock server that always returns hello
let mockClient = MockGetServer(MyGetRoute.self){ request in
    return ("Received",URLSession())
}

try await MyGetRoute.get(parameters:[],client : mockClient)
```
Moreover than that, all Client side protocols provide an appropriate mockClient depending on their type:
```swift
let response = try await MyPostRoute.send("some data",
                                            client: MyPostRoute.mockClient(always:true))
```
You can also mock server error :
```swift
let error = VaporError(error:true, reason:"This is a test")
let response = try await MyPostRoute.send("some data",
                            client: MyPostRoute.mockClient(throws:error))
```
### Pro Tip:
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



