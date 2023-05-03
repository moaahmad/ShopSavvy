// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]
        ),
    ],
    dependencies: [
        .package(
            name: "CoreKit",
            path: "../Packages/CoreKit"
        )
    ],
    targets: [
        .target(
            name: "NetworkKit",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: [
                "NetworkKit",
                "CoreKit"
            ]
        ),
    ]
)
