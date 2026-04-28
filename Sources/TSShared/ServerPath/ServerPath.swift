//
//  ServerPath.swift
//  TSShared
//
//  Created by MohammavDev on 4/21/26.
//

import Foundation
import OSLog




///Type that is used to create a path for your routes.
///
///ServerPath can be created in may different way depending on your needs
///```swift
///let path = try ServerPath(string:"users/:id")
///let path2 = ServerPath(parts : ["users",":id"])
///let path3 : ServerPath = "admins"
///let path4 : ServerPath = [path3,"users/:id"] // --> admins/users/:id
///```
///In order to group your routes by path, simply create static variables on ServerPath:
///```swift
///extension ServerPath{
/// static let admins : ServerPath = "users/admin"
/// }
///
/////and then in your route path you can have :
///
///public struct AdminSignInRoute : RouteProtocol{
///     //....
///     static let path : ServerPath = [.admins, "signin"] // "users/admin/signin"
///}
///```
public struct ServerPath : Communicatable, Hashable{
    
    
    
    public var value : String {
        self.parts.map{$0.value}.joined(separator: "/")
    }
    
    
    public var parts : [PathPart]
    
    public init(parts: [PathPart]) {
        self.parts = parts
    }
}


extension ServerPath : CustomStringConvertible{
    public var description: String {
        return "/" + parts.map{$0.description}.joined(separator: "/")
    }
    
    public  var pathWithoutFirstSlash: String {
        if value.starts(with: "/"){
            return String(value.dropFirst())
        }
        return value
    }
    
    public var pathWithFirstSlash: String {
        if value.starts(with: "/"){
            return value
        }
        return "/" + value
    }
    
   
}


