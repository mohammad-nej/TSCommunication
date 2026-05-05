# ``TSVapor``

Make routes in your server Type-Safe, DSL to organize and insert your routes

## Overview
This package introduces more protocols, DSL for adding your route to vapor, and helper functions to help you with your routes.
## Protocols
Just like the client side, this package also introduce 6 main protocols.

@TabNavigator{
   @Tab("ServerGetRouteProtocol"){

        extend routes conforming to `GetHttpRoute`, to this protocol .

        ```swift
        extension PingRoute : ServerGetRouteProtocol{
            static var closure: @Sendable (Vapor.Request) async throws -> PingRoute.OutputData{
                return { req in 
                    //Assuming your route output is Bool
                    return true
                }
            }
        }
        ```
    }
    @Tab("ServerRouteProtocol"){

        extend your ``TSShared/HttpRoute``s to this protocol.
        ```swift
        extension AddContactsRoute : ServerRouteProtocol{
            static var closure: @Sendable (Vapor.Request) async throws -> PingRoute.OutputData{
                return { req in 
                    //do your stuff in here
                }
            }

        }
    ```
   }
    
    @Tab("ServerFileDownloadable"){

        extend your ``FileDownloadable`` route to conform to this protcol.
        
        - Note: in this case the output type of the closure is not your route `OutputData` but **Vapor.Response** instead. This is because vapor needs you to send the `Response` object back when streaming a file to client
        ```swift
        extension MyFileUploadRoute : ServerFileDownloadable{
            static var closure: @Sendable (Vapor.Request) async throws -> Vapor.Response{
                return { req in
                    //do your stuff in here
                    let response = try await MyDownloadRoute
                                        .send(file: fileURL,
                                        request: req)
                    return response
                }
            }
        }
        ```
        You can use provided `send(file:URL,request:Request)` function to stream your file to client.
    }  
    @Tab("ServerLargeFileUploadable"){

        extend your ``LargeFileUploadable`` routes to conform to this protocol.
        ```swift
        extension MyLargeFileUploader : ServerLargeFileDownloadable{
            static var closure: @Sendable (Vapor.Request) async throws -> OutputData{
                return { req in
                    //do your stuff in here
                    return true
                }
            }
        }
        ```
    }
    
    @Tab("ServerFileUploadable"){

        extend your ``FileUploadable`` routes to conform to this protcol.
        ```swift
        extension MyLargeFileUploader : ServerFileUploadable{
            static var closure: @Sendable (Vapor.Request) async throws -> OutputData{
                return { req in
                    //do your stuff in here
                    return true
                }
            }
        }
        ```
    } 
    @Tab("ServerWebSocket"){

        extend your ``WebScoketRoute`` routes to conform to this protocol.
        ```swift
         extension MyWebSocketRoute : ServerWebSocket{
             static var onUpgrade : WebSocketOnUpgrade {
                 return { req,ws in
                     //...
                 }
             }
        }

        ```
    } 
}
## DSL
This target provides a DSL to help you organize , add middlewares(s) and inserting your routes to Vapor.
You can group your routes using ``Group`` for organizing your routes
```swift
let adminRoutes = Group{
    FirstRoute.self
    SecondRoute.self
    Group{
        Third.self
    }
}
```
You can then put your routes behind your middleware(s) using ``With``
```swift
let routesUnderMiddleware = With(middleware: AdminsMiddleware()){
    adminRoute
    With(middlewares:[First(),Second()]){
        SomeOtherRoute.self
    }
}
```
Note that in the example above all **3** middlewares will be applied to `SomeOtherRoute`.

Finally, use ``RouteInserter`` to wrap up everything and insert your routes into vapor:
```swift
let duplicates = RouteInserter{
    AnotherRoute.self
    routesUnderMiddleware
    //...
}.duplicates
```
``RouteInserter`` will deduplicate your routes and provide a ``RouteInserter/duplicates`` array of the duplicated routes found while inserting to vapor.

