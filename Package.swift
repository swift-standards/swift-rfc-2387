// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-rfc-2387",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "RFC 2387",
            targets: ["RFC 2387"]
        )
    ],
    dependencies: [
        .package(path: "../swift-rfc-2045"),
        .package(path: "../swift-rfc-2046")
    ],
    targets: [
        .target(
            name: "RFC 2387",
            dependencies: [
                .product(name: "RFC 2045", package: "swift-rfc-2045"),
                .product(name: "RFC 2046", package: "swift-rfc-2046")
            ]
        ),
        .testTarget(
            name: "RFC 2387 Tests",
            dependencies: ["RFC 2387"]
        )
    ]
)

for target in package.targets {
    target.swiftSettings?.append(
        contentsOf: [
            .enableUpcomingFeature("MemberImportVisibility")
        ]
    )
}
