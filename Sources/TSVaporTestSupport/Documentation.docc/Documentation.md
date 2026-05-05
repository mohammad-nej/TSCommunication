# ``TSVaporTestSupport``

Makes testing your server easier

## Overview
This package is all about making your tests easier by extending both Vapor and TSVapor types to let you test your routes with ease.
## ServerTest
This type lets you create an instance of `Application` on test mode, do some preparations( like preparing your db, ... ), cleanups and error cleanups before/after  testing your routes.
```swift
let tester = ServerTest{ app in 
    //do your preparation setup in here
}

try await tester.withApp{ app in 
    app.testing().test(MyRoute.self){ req in 
        //create request
    }afterResponse:{ response in
        //check the output
    }
}
```
- Important: `withApp` function will create and destroy an instance of `Application` , meaning that each time you call it, all your preparation/cleanup closures will rerun.
## Testing Routes
While ``ServerTest`` can be useful to test multiple routes at once, if you want to test a single route in your test function, there are better ways :
```swift
MyRouteToTest.test(preparation: preparationClosure){ request in 
    //prepare request
}afterResponse:{ response in
    //check the response
}
```
Use `preparation` closure to setup your `Application`, if your route doesn't need any setup, use the provided static variable ``insertToApp``, which will just insert current route to server.

When creating a test, routes that can have an `InputData` can use  `insert(_:InputData ,in: inout TestingHTTPRequest) throws` function to insert your input to test request.

An `output(from: TestingHTTPResponse) throws -> OutputData` is also provided to extract your output from test response.

```swift
MyRouteToTest.test(preparation: preparationClosure){ request in 
    try MyRouteToTest.insert("sample",in:&request) //assuming MyRouteToTest.InputData == String
}afterResponse:{ response in
    let output = try MyRouteToTest.output(from: response)
}
```
@TabNavigator{
    @Tab("ServerFileUploadable"){
        Routes that conform to this protocol, have an static function `modifyRequest` that will modify your test request to create a MultiPart test request for you.
        ```swift
        MyUploadableRoute.test(preparation: preparationClosure){ request in 
            try MyUploadableRoute.modifyRequest(metaData:"Extra info",filename:"myfile.txt",
                                                data:fileData,using: &request)
        }afterResponse:{ response in
            let output = try MyRouteToTest.output(from: response)
        }
        ```
    }
    @Tab("ServerLargeFileUploadable"){
        Routes conforming to this protocol, have an static function `upload(_: Data,in: inout TestingHTTPRequest)` that injects your data into test requests body.
        ```swift
        UploadLargeFileRoute.test(preparation: preparationClosure){ request in 
            UploadLargeFileRoute.upload(fileData, in &request)
        }afterResponse:{ response in
            //...
        }
        ```
    }

}
## Topics

