// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TouchGuard",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "TouchGuardApp", targets: ["TouchGuardApp"])
    ],
    targets: [
        .target(
            name: "TouchBarSupport",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "TouchGuardApp",
            dependencies: ["TouchBarSupport"]
        ),
        .testTarget(
            name: "TouchGuardAppTests",
            dependencies: ["TouchGuardApp"]
        )
    ]
)
