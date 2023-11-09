// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "scannerPkg",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "scannerPkg",
            targets: ["scannerPkg"]),
    ],
    dependencies: [
      
    ],
    targets: [
        .target(
            name: "scannerPkg",
            dependencies: []),
        .testTarget(
            name: "scannerPkgTests",
            dependencies: ["scannerPkg"]),
    ]
)
