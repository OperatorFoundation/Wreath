// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wreath",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "WreathClient",
            targets: ["WreathClient"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.4"),
        .package(url: "https://github.com/OperatorFoundation/ShadowSwift", branch: "main"),
        .package(url: "https://github.com/OperatorFoundation/Antiphony", branch: "main"),
    ],
    targets: [
        .target(name: "Wreath",
               dependencies: [
                .product(name: "Antiphony", package: "Antiphony"),
                .product(name: "ShadowSwift", package: "ShadowSwift"),
               ]),
        .target(name: "WreathClient",
               dependencies: [
                "Wreath",
                .product(name: "Antiphony", package: "Antiphony"),
               ]),
        .executableTarget(
            name: "WreathServer",
            dependencies: [
                "Wreath",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Antiphony", package: "Antiphony"),
            ]),
        .testTarget(
            name: "WreathTests",
            dependencies: []
        ),
    ]
)
