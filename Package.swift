// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ScreenshotLauncher",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "ScreenshotLauncher", targets: ["ScreenshotLauncher"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ScreenshotLauncher",
            path: "Sources/ScreenshotLauncher",
            resources: [
                .process("../../ScreenshotLauncherIcon.icns"),
                .process("../../Info.plist")
            ]
        )
    ]
)
