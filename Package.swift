// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftUILineChart",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftUILineChart",
            targets: ["SwiftUILineChart"]),
    ],
    targets: [
        .target(
            name: "SwiftUILineChart",
            dependencies: []),
    ]
)
