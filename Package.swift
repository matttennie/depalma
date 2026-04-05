// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "depalma",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "depalma", targets: ["depalma"])
    ],
    targets: [
        .target(
            name: "TouchBarSupport",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "depalma",
            dependencies: ["TouchBarSupport"]
        ),
        .testTarget(
            name: "depalmaTests",
            dependencies: ["depalma"]
        )
    ]
)
