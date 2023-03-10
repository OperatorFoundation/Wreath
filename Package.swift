// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wreath",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "WreathClient",
            targets: ["WreathClient"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4"),
        .package(url: "https://github.com/OperatorFoundation/Antiphony", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Arcadia.git", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/WreathBootstrap.git", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/ShadowSwift", branch: "main")
    ],
    targets: [
        .target(name: "Wreath",
               dependencies: [
                .product(name: "Antiphony", package: "Antiphony"),
                .product(name: "ShadowSwift", package: "ShadowSwift"),
               ]),
        .target(name: "WreathClient",
               dependencies: [
                "Antiphony",
                "Wreath"
               ]),
        .executableTarget(
            name: "WreathServer",
            dependencies: [
                "Antiphony",
                "Arcadia",
                "Wreath",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "WreathBootstrapClient", package: "WreathBootstrap")
            ]),
        .testTarget(
            name: "WreathTests",
            dependencies: ["Wreath", "WreathClient", "WreathServer"]
        ),
    ]
)
