// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]),
    ],
    dependencies: [
        .package(
            name: "CoreKit",
            path: "../Packages/CoreKit"
        ),
        .package(
            name: "ModelKit",
            path: "../Packages/ModelKit"
        ),
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            from: "7.6.2"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.11.0"
        )
    ],
    targets: [
        .target(
            name: "DesignKit",
            dependencies: [
                "CoreKit",
                "ModelKit"
            ]
        ),
        .testTarget(
            name: "DesignKitTests",
            dependencies: [
                "DesignKit",
                "ModelKit",
                .product(
                    name: "SnapshotTesting",
                    package: "swift-snapshot-testing"
                ),
                .product(
                    name: "Kingfisher",
                    package: "kingfisher"
                )
            ]
        ),
    ]
)
