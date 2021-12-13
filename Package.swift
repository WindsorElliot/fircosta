// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fircosta",
    platforms: [
        .iOS(.v12),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "fircosta",
            targets: ["fircosta"]),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.0.0")),
    ],
    targets: [
        .target(
            name: "fircosta",
            dependencies: [
                .product(name: "FirebaseDatabase", package: "Firebase"),
                .product(name: "FirebaseAuth", package: "Firebase")
            ]),
        .testTarget(
            name: "fircostaTests",
            dependencies: ["fircosta"]),
    ]
)
