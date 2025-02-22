// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "VaporHotReload",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // 🔥 A Swift package for reloading code at runtime
        .package(url: "https://github.com/ShaftUI/SwiftReload.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                "SwiftReload",
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings,
            linkerSettings: linkerSettings
        ),
    ],
    swiftLanguageModes: [.v5]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("DisableOutwardActorInference"),
        .enableExperimentalFeature("StrictConcurrency"),
        // Enable private imports for hot reload
        .unsafeFlags(
            ["-Xfrontend", "-enable-private-imports"],
            .when(configuration: .debug)
        ),
        // Enable implicit dynamic for hot reload
        .unsafeFlags(
            ["-Xfrontend", "-enable-implicit-dynamic"],
            .when(configuration: .debug)
        ),
    ]
}

var linkerSettings: [LinkerSetting] {
    [
        // Export dynamic symbols for hot reload
        .unsafeFlags(
            ["-Xlinker", "--export-dynamic"],
            .when(platforms: [.linux, .android], configuration: .debug)
        )
    ]
}
