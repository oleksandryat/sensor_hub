// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "sensorhub_stats",
  platforms: [.iOS("13.0")],
  products: [
    .library(name: "sensorhub-stats", targets: ["sensorhub_stats"])
  ],
  targets: [
    .target(name: "sensorhub_stats")
  ]
)
