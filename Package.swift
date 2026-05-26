// swift-tools-version: 6.0

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
      dependencies: [],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    )
  ],
  swiftLanguageModes: [.v6]
)
