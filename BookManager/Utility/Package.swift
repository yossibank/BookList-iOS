// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Utility",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Utility",
            type: .dynamic,
            targets: [
                "Utility"
            ]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Utility",
            dependencies: []
        ),
        .testTarget(
            name: "UtilityTests",
            dependencies: [
                "Utility"
            ]
        )
    ]
)
