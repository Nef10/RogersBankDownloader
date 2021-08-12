// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RogersBankDownloader",
    products: [
        .library(
            name: "RogersBankDownloader",
            targets: ["RogersBankDownloader"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RogersBankDownloader",
            dependencies: []),
        .testTarget(
            name: "RogersBankDownloaderTests",
            dependencies: ["RogersBankDownloader"]),
    ]
)
