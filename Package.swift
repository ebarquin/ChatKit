// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChatKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ChatKit",
            targets: ["ChatKit"]
        )
    ],
    targets: [
        .target(
            name: "ChatKit",
            path: "Sources/ChatKit"
        ),
        .testTarget(
            name: "ChatKitTests",
            dependencies: ["ChatKit"]
        )
    ]
)
