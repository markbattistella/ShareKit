// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ShareKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ShareKit",
            targets: ["ShareKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ShareKit",
            dependencies: []
        )
    ]
)
