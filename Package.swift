// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "YMKitX",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: darwinProducts() + universalProducts(),
    targets: darwinTargets() + universalTargets(),
)

private func darwinProducts() -> [Product] {
    #if canImport(Darwin)
    [
        .library(
            name: "YMMisc",
            targets: ["YMMisc"],
        ),
        .library(
            name: "YMValidationKit",
            targets: ["YMAppValidation"],
        ),
    ]
    #else
    []
    #endif
}

private func universalProducts() -> [Product] {
    [
        .library(
            name: "YMKitX",
            targets: ["YMKitX"],
        ),
        .library(
            name: "YMMonitoring",
            targets: ["YMMonitoring"],
        ),
    ]
}

private func darwinTargets() -> [Target] {
    #if canImport(Darwin)
    [
        .target(
            name: "YMAppReceiptValidation",
            path: "AppReceiptValidation/src",
        ),
        .testTarget(
            name: "YMAppReceiptValidationTests",
            dependencies: ["YMAppReceiptValidation"],
            path: "AppReceiptValidation/test",
        ),
        .target(
            name: "YMAppValidation",
            dependencies: ["YMAppReceiptValidation"],
            path: "AppValidation/src",
        ),
        .testTarget(
            name: "YMAppValidationTests",
            dependencies: ["YMAppValidation"],
            path: "AppValidation/test",
        ),
        .target(
            name: "YMMisc",
            path: "Misc/src",
        ),
        .testTarget(
            name: "YMMiscTests",
            dependencies: ["YMMisc"],
            path: "Misc/test",
        ),
    ]
    #else
    []
    #endif
}

private func universalTargets() -> [Target] {
    [
        .target(
            name: "YMKitX",
            path: "Kit/src",
        ),
        .testTarget(
            name: "YMKitXTests",
            dependencies: ["YMKitX"],
            path: "Kit/test",
        ),
        .target(
            name: "YMMonitoring",
            path: "Monitoring/src",
        ),
        .testTarget(
            name: "YMMonitoringTests",
            dependencies: ["YMMonitoring"],
            path: "Monitoring/test",
        ),
        .target(
            name: "YMUtilities",
            path: "Utilities/src",
        ),
        .testTarget(
            name: "YMUtilitiesTests",
            dependencies: ["YMUtilities"],
            path: "Utilities/test",
        ),
    ]
}
