import Foundation




///A route that can send/receive json to/from server
///
/// A route can be created by conforming to this type:
/// ```swift
///struct EchoRoute : HttpRoute {
///    typealias InputData = String
///    typealias OutputData = String
///
///    static let path: TSShared.ServerPath = "echo"
///    static let method: TSShared.HttpMethod = .POST
///    static let contentType: ContentType = .json
///}
///```
///This will provide base information for TSClient and TSVapor packages to
///work with routes.
public protocol HttpRoute: InputOutputableRoute {

}

public extension HttpRoute{
    static var routeDescription: String {
        "\(Self.method.rawValue.uppercased()), \(Self.path)"
    }

}




