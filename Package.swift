// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "YMKitX",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "YMKitX",
            targets: ["YMKitX"],
        ),
    ],
    targets: [
        .target(
            name: "YMKitX",
            path: "Kit/src",
        ),
        .testTarget(
            name: "YMKitXTests",
            dependencies: ["YMKitX"],
            path: "Kit/test",
        ),
    ]
)
