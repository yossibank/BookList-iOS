// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DomainKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DomainKit",
            targets: [
                "DomainKit"
            ]
        )
    ],
    dependencies: [
        .package(url: "./APIKit", from: "1.0.0"),
        .package(url: "./Utility", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DomainKit",
            dependencies: [
                .product(name: "APIKit", package: "APIKit"),
                .product(name: "Utility", package: "Utility")
            ]
        ),
        .testTarget(
            name: "DomainKitTests",
            dependencies: [
                "DomainKit"
            ]
        )
    ]
)
