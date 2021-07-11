// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "APIKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "APIKit",
            targets: [
                "APIKit"
            ]
        )
    ],
    dependencies: [
        .package(url: "./Utility", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "APIKit",
            dependencies: [
                .product(name: "Utility", package: "Utility")
            ],
            resources: [
                .process("TestData")
            ]
        ),
        .testTarget(
            name: "APIKitTests",
            dependencies: [
                "APIKit"
            ]
        )
    ]
)
