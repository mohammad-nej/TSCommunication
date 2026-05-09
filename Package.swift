// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "TSCommunication",
    platforms: [
        .macOS(.v13), .iOS(.v18)
    ],
    
    products: [
        .library(name: "TSShared", targets: ["TSShared"]),
        .library(name: "TSVapor", targets: ["TSVapor"]),
        .library(name: "TSClient", targets: ["TSClient"]),
        
        // reusable test utilities
        .library(name: "TSVaporTestSupport", targets: ["TSVaporTestSupport"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    
    targets: [
        
        // MARK: Shared
        .target(name: "TSShared"),
        
        // MARK: Server
        .target(
            name: "TSVapor",
            dependencies: [
                "TSShared",
                .product(name: "Vapor", package: "vapor")
            ]
        ),
        
        // MARK: Client
        .target(
            name: "TSClient",
            dependencies: [
                "TSShared"
            ]
        ),
        
        // MARK: Test Support (reusable)
        .target(
            name: "TSVaporTestSupport",
            dependencies: [
                "TSVapor",
                "TSShared",
                .product(name: "VaporTesting", package: "vapor")
            ]
        ),
        
        // MARK: Tests
        
        .testTarget(
            name: "TSVaporTests",
            dependencies: [
                "TSVapor",
                "TSVaporTestSupport",
                "TSShared"
            ]
        ),
        
        .testTarget(
            name: "TSClientTests",
            dependencies: [
                "TSClient",
                "TSShared"
            ]
        ),
        
        .testTarget(
            name: "TSSharedTests",
            dependencies: [
                "TSShared"
            ]
        ),
        
        .testTarget(
            name: "TSVaporTestSupportTests",
            dependencies: [
                "TSVaporTestSupport",
                "TSVapor",
                "TSShared"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
