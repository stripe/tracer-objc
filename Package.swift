// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Tracer",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "Tracer",
            targets: ["Tracer"]
        ),
    ],
    targets: [
        .target(
            name: "Tracer",
            path: "Tracer",
            exclude: ["Info.plist"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("Private"),
            ]
        ),
        .testTarget(
            name: "TracerTests",
            dependencies: ["Tracer"],
            path: "TracerTests",
            exclude: ["Info.plist"],
            resources: [
                .process("saved_trace.json"),
                .process("trace_bt_scan_connect.json"),
            ],
            cSettings: [
                // Package root, so tests can use `#import <Tracer/Tracer.h>`.
                .headerSearchPath(".."),
                .headerSearchPath("../Tracer/Private"),
            ]
        ),
    ]
)
