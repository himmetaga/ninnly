// swift-tools-version: 6.0
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
    ],
    // .iOS(.v18) / .watchOS(.v11) 6.0 araç sürümü ister; dil kipi uygulamayla aynı (Swift 5)
    swiftLanguageModes: [.v5]
)
