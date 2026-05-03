//
//  Group.swift
//  TSCommunication
//
//  Created by MohammavDev on 4/30/26.
//


import Foundation
import TSShared
import Vapor


///Creates an array of routes
///
///You can group your routes before adding them to ``RouteInserter`` or ``With``
///```swift
///let adminRoutes = Group{
/// ChangeSettings.self
/// //...
///}
///```
public struct Group {
    let routes: [any IdentifiableRoute.Type]
    public init(@GroupResultBuilder _ closure : () -> [any IdentifiableRoute.Type]){
        self.routes = closure()
    }
}
