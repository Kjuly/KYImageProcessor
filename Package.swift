// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "KYImageProcessing",
  defaultLocalization: "en",
  platforms: [
    .iOS("15.5"),
  ],
  products: [
    .library(
      name: "KYImageProcessing",
      targets: [
        "KYImageProcessing",
      ]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "KYImageProcessing",
      dependencies: [
      ],
      path: "KYImageProcessing/Sources",
      resources: [
        .process("Resources/"),
      ]),
    .testTarget(
      name: "KYImageProcessingTests",
      dependencies: [
        "KYImageProcessing",
      ],
      path: "KYImageProcessingTests"),
  ]
)
