#  Overview
This package is all about making communication between Client/Server **Type Safe** and easy.

The main idea is to create a single type per each route in your server. This types are created in a Shared package that both server/client have access to, on those type you have to enter the base requirements for your routes, including path, http method, ... .

Because targets in this package work independent of each other (except `TSShared`), You can use this package even if your server is not written using Swift.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmohammad-nej%2FTSCommunication%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mohammad-nej/TSCommunication)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmohammad-nej%2FTSCommunication%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mohammad-nej/TSCommunication)

## Pros:
Using this package has it's pros and cons
### In General
- Make your routes Input/Output type-safe
- Fully customizable thanks to POP design
### Client side:
- Checks your parameters count before sending a request
- Makes sending a request to server easier
- Makes decoding server response easier
- Provides Mocks for testing your client app 
### Server side 
- Provides DSL for inserting your routes to server
- Deduplicates your routes before inserting them to server
- Makes testing your routes easier
## Cons:
- More boilerplate, cause you have to declare a type for each route

# TSSHared
 ``TSSHared`` package provides 6 different protocols for creating a route. for example:
 ```swift
public enum AddContactsRoute : HttpRoute { 
    public typealias InputData = ContactDTO
    public typealias OutputData = Bool
    
    public static let path : ServerPath = "/addContacts"
    public static let method : HttpMethod = .POST
}
 ```
By creating this type, both server and client knows about Input/Output type of your route, path to the route , http method used by this route. This will let us make our communication type safe.

It's a good idea to define all your routes as Enum cause instantiating a route doesn't really mean anything.
# TSClient
Once you have defined your routes in your shared package, `TSClient` can be used to provide some helper functions. All you need to do is to extend your routes, to client side protocols 
```swift 
extension AddContactsRoute : ClientHttpRoute {} //Thats it ! 
```
each Client side protocol provides appropriate methods for the job. 
```swift
let output = try await AddContactsRoute.send(contactDtO, server : .server ).asOutput
```
This line will your send a ContactDTO to server, get back the response and convert to OutputData( in this case Bool).
# TSVapor
Just like the client side , you can use the types defined in your shared package to define routes in your vapor server.

All you need to do is to extend your protocols, to the appropriate server side protocol 
```swift
extension AddContactsRoute : ServerHttpRoute{
    public var closure : (Request) async throws -> Bool { // Bool == AddContactsRoute.OutputData
        return { req in 
            //you route logic in here
            let dto = try Self.input(from: req) // dto -> ContactsDTO == InputData
        }
    }
}
```

Once you have created your routes, you can insert them into vapor, using the provided DSL
```swift
RouteInserter{
    AddContactsRoute.self
}
```

This is just an overview of this package, make sure to check the documentation for more information.
# TSVaporTestSupport
This package lets you, test your routes easier
```swift
@Test("Test contacts route")
func testAdd(){
    AddContactsRoute.test(preparation:preparationClosure){ req in 
        let dto = ContactDTO(..)
        AddContactsRoute.insert(dto, in:&req)
    }afterResponse{ response in 
        let result = try AddContactsRoute.output(from: response) //result -> Bool
        #expect(result)
    }
}
```
# Conclusion
This was just an overview of what can be done with this package, This package provides many customizations like custom JSONDecoder/JSONEncoder for your routes, custom Failure type for errors emitted to client, adding middleware and much more, make sure to check the documentations for more information.

Currently, Only Vapor is supported on the server-side, support for Hummingbird will be added later on.

Feel free to contact me at : `mohammad.nej@gmail.com`.
