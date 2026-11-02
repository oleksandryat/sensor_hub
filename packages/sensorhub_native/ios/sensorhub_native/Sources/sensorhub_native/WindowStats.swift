import Foundation

/// Mean, population standard deviation and z-score of `value` against `window`; mirrors the C library.
enum WindowStats {
  static func analyze(window: [Double], value: Double) -> (mean: Double, stdDev: Double, zScore: Double) {
    guard !window.isEmpty else { return (0, 0, 0) }
    let mean = window.reduce(0, +) / Double(window.count)
    let variance = window.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(window.count)
    let stdDev = variance.squareRoot()
    let z = window.count >= 3 && stdDev > 1e-9 ? (value - mean) / stdDev : 0
    return (mean, stdDev, z)
  }
}

final class WindowStatsHandler: WindowStatsApi {
  func analyzeWindow(window: [Double], value: Double) throws -> WindowStatsMessage {
    let r = WindowStats.analyze(window: window, value: value)
    return WindowStatsMessage(mean: r.mean, stdDev: r.stdDev, zScore: r.zScore)
  }
}
