// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSBlankWorkers
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSBlankWorkers",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSBlankWorkers",
            type: .static,
            targets: ["DNSBlankWorkers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2")),
        .package(url: "https://github.com/DoubleNode/DNSBlankNetwork.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSCrashNetwork.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSDataContracts.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSDataObjects.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSDataTypes.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSError.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSProtocols.git", .upToNextMajor(from: "1.12.0")),
//        .package(path: "../DNSBlankNetwork"),
//        .package(path: "../DNSCore"),
//        .package(path: "../DNSCrashNetwork"),
//        .package(path: "../DNSDataContracts"),
//        .package(path: "../DNSDataObjects"),
//        .package(path: "../DNSDataTypes"),
//        .package(path: "../DNSError"),
//        .package(path: "../DNSProtocols"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSBlankWorkers",
            dependencies: ["Alamofire", "DNSBlankNetwork", "DNSCore", "DNSCrashNetwork", "DNSDataContracts", "DNSDataObjects", "DNSDataTypes", "DNSError", "DNSProtocols"]),
        .testTarget(
            name: "DNSBlankWorkersTests",
            dependencies: ["DNSBlankWorkers", "DNSBlankNetwork"]),
    ],
    swiftLanguageVersions: [.v5]
)
