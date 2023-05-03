// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModelKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ModelKit",
            targets: ["ModelKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ModelKit",
            dependencies: []
        )
    ]
)
