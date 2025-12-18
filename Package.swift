// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Panels",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "Panels",
            targets: ["Panels"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.2.0")
        )
    ],
    targets: [
        .target(
            name: "Panels",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ],
        ),
    ]
)
