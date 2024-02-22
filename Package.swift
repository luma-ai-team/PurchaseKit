// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PurchaseKit",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(name: "PurchaseKitCore", targets: ["PurchaseKitCore"]),
        .library(name: "PurchaseKitUI", targets: ["PurchaseKitUI"]),
        .library(name: "PurchaseKitAdapty", targets: ["PurchaseKitAdapty"]),
        .library(name: "PurchaseKitModules", targets: ["PurchaseKitModules"])
    ],
    dependencies: [
        .package(url: "https://github.com/adaptyteam/AdaptySDK-iOS.git", .upToNextMajor(from: "2.2.0")),
        //.package(url: "https://github.com/luma-ai-team/CoreUI.git", branch: "master"),
        .package(name: "LumaKit", path: "../LumaKit"),
        .package(url: "https://github.com/disabled/GenericModule", branch: "master")
    ],
    targets: [
        .target(
            name: "PurchaseKitCore",
            dependencies: [
                .product(name: "GenericModule", package: "GenericModule"),
                .product(name: "LumaKit", package: "LumaKit")
            ],
            path: "Sources/PurchaseKitCore",
            resources: []),
        .target(
            name: "PurchaseKitUI",
            dependencies: [
                .target(name: "PurchaseKitCore"),
                .product(name: "LumaKit", package: "LumaKit")
            ],
            path: "Sources/PurchaseKitUI",
            resources: [.process("Resources")]),
        .target(
            name: "PurchaseKitAdapty",
            dependencies: [
                .target(name: "PurchaseKitCore"),
                .product(name: "Adapty", package: "AdaptySDK-iOS")
            ],
            path: "Sources/PurchaseKit+Adapty",
            resources: []),
        .target(
            name: "PurchaseKitModules",
            dependencies: [
                .target(name: "PurchaseKitCore"),
                .target(name: "PurchaseKitUI"),
                .product(name: "LumaKit", package: "LumaKit"),
                .product(name: "GenericModule", package: "GenericModule")
            ],
            path: "Sources/PurchaseKitModules"),
    ]
)
