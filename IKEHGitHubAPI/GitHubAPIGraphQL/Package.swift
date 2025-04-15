// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "GitHubAPIGraphQL",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(name: "GitHubAPIGraphQL", targets: ["GitHubAPIGraphQL"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "1.19.0"),
  ],
  targets: [
    .target(
      name: "GitHubAPIGraphQL",
      dependencies: [
        .product(name: "Apollo", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
  ]
)
