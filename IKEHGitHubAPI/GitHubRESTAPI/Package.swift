// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubRESTAPI",
    platforms: [
      .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GitHubRESTAPI",
            targets: ["GitHubRESTAPI"]),
    ],
    dependencies: [
        
        .package(url: "https://github.com/apple/swift-http-types", from: "1.3.1")
    ],
    targets: [
        .target(
            name: "GitHubRESTAPI",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types")
            ],
        ),
        .testTarget(
            name: "GitHubRESTAPITests",
            dependencies: ["GitHubRESTAPI"]
        ),
    ]
)
