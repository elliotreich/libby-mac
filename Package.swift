// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "LibbyMac",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "LibbyMac", targets: ["LibbyMac"])
    ],
    targets: [
        .executableTarget(
            name: "LibbyMac",
            path: "Sources/LibbyMac"
        )
    ]
)
