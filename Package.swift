// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-rfc-2387",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: "RFC 2387",
            targets: ["RFC 2387"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-incits-4-1986", from: "0.3.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-2045", from: "0.2.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-2046", from: "0.2.1"),
        .package(url: "https://github.com/swift-standards/swift-rfc-5322", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "RFC 2387",
            dependencies: [
                .product(name: "INCITS 4 1986", package: "swift-incits-4-1986"),
                .product(name: "RFC 2045", package: "swift-rfc-2045"),
                .product(name: "RFC 2046", package: "swift-rfc-2046"),
                .product(name: "RFC 5322", package: "swift-rfc-5322")
            ]
        ),
        .testTarget(
            name: "RFC 2387".tests,
            dependencies: ["RFC 2387"]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
