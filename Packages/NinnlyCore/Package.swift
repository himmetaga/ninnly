// swift-tools-version: 5.10
// Ninnly çekirdek iş kuralları paketi (arayüzden bağımsız, yalnız Foundation)

import PackageDescription

let package = Package(
    name: "NinnlyCore",
    platforms: [
        .iOS(.v18),
        .watchOS(.v11),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "NinnlyCore",
            targets: ["NinnlyCore"]
        )
    ],
    targets: [
        .target(
            name: "NinnlyCore"
        ),
        .testTarget(
            name: "NinnlyCoreTests",
            dependencies: ["NinnlyCore"]
        )
    ]
)
