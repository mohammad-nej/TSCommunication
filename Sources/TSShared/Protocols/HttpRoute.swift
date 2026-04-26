import Foundation




///Fundamentals of a route that is used by Server and Client
///
/// A route can be created by conforming to this type:
/// ```swift
///struct EchoRoute : HttpRoute {
///    typealias InputData = String
///    typealias OutputData = String
///
///    static let path: TSShared.ServerPath = "echo"
///    static let method: TSShared.HttpMethod = .post
///    static let contentType: ContentType = .json
///}
///```
///This will provide base information for TSClient and TSVapor packages to
///work with routes.

public protocol HttpRoute: GetHttpRoute,Sendable {
    associatedtype InputData : Codable
    
           
    static var contentType : ContentType { get }
    static var path: ServerPath { get }
    static var method : HttpMethod { get }
}

public extension HttpRoute{
    static var routeDescription: String {
        "\(Self.method.rawValue.uppercased()), \(Self.path)"
    }
    static var contentType: ContentType { .json }
}




