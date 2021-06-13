// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Data",
            targets: [
                "Data"
            ]
        ),
    ],
    dependencies: [
        .package(url: "./Utility", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Utility", package: "Utility")
            ],
            resources: [
                .process("TestData")
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data"
            ]
        ),
    ]
)
