//
//  AddableRoute.swift
//  Whisper
//
//  Created by MohammavDev on 4/19/26.
//

import TSShared
import Vapor


///This is the base protocol for all route protocols in this package.
///
///This protocol can be used to cast all kinds of routes to `any AddableRoute` letting you to insert them in your vapor route in one big array
///```swift
/////in your vapor routes file
///let route1 = SampleServerRoute()
///let route2 = SampleDownloadableRoute()
///let route3 = SampleUploadableRoute()
///
///let routes : [any AddableRoute] = [route1,
/// route2,
/// route3]
///routes.forEach{$0.addRoute(to:app)
///```
public protocol AddableRoute {
    func addRoute(to : Application) throws
}
