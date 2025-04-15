// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitHubAPIClient",
    platforms: [
        .iOS(.v17),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "GitHubAPIClient",
            targets: ["GitHubAPIClient"]),
    ],
    dependencies: [
        // インポートするライブラリの指定
        .package(path: "../GitHubRESTAPI"),
        .package(path: "../GitHubAPIGraphQL"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.0.0"),
    ],
    targets: [
        // ターゲットごとに利用するライブラリの指定
        .target(
            name: "GitHubAPIClient",
            dependencies: [
                "GitHubRESTAPI",
                "GitHubAPIGraphQL",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
            ],
            swiftSettings: [
                // マクロを使うなら `macros` セクションを追加する必要がある
                .enableUpcomingFeature("Macros"),
//                .enableExperimentalFeature("StrictConcurrency")
            ],
        ),
        .testTarget(
            name: "GitHubAPIClientTests",
            dependencies: ["GitHubAPIClient"]
        ),
    ]
)
