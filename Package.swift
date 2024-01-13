// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "KYImageProcessor",
  defaultLocalization: "en",
  platforms: [
    .iOS("15.5"),
    .watchOS(.v6),
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "KYImageProcessor",
      targets: [
        "KYImageProcessor",
      ]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "KYImageProcessor",
      dependencies: [
      ],
      path: "KYImageProcessor/Sources",
      resources: [
        .process("Resources/"),
      ]),
    .testTarget(
      name: "KYImageProcessorTests",
      dependencies: [
        "KYImageProcessor",
      ],
      path: "KYImageProcessorTests"),
  ]
)
