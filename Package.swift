// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MesadaKids",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "MesadaCore", targets: ["MesadaCore"]),
        .library(name: "MesadaUI", targets: ["MesadaUI"]),
        .executable(name: "MesadaKids", targets: ["MesadaKids"])
    ],
    targets: [
        .target(name: "MesadaCore"),
        .target(
            name: "MesadaUI",
            dependencies: ["MesadaCore"]
        ),
        .executableTarget(
            name: "MesadaKids",
            dependencies: ["MesadaCore"]
        ),
        .testTarget(
            name: "MesadaCoreTests",
            dependencies: ["MesadaCore"]
        )
    ]
)
