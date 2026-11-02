package com.sensorhub.sensorhub_native

import kotlin.math.sqrt

/// Mean, population standard deviation and z-score of [value] against [window]; mirrors the C library.
object WindowStats {
  fun analyze(window: List<Double>, value: Double): Triple<Double, Double, Double> {
    if (window.isEmpty()) return Triple(0.0, 0.0, 0.0)
    val mean = window.sum() / window.size
    val stdDev = sqrt(window.sumOf { (it - mean) * (it - mean) } / window.size)
    val z = if (window.size >= 3 && stdDev > 1e-9) (value - mean) / stdDev else 0.0
    return Triple(mean, stdDev, z)
  }
}

class WindowStatsHandler : WindowStatsApi {
  override fun analyzeWindow(window: List<Double>, value: Double): WindowStatsMessage {
    val (mean, stdDev, z) = WindowStats.analyze(window, value)
    return WindowStatsMessage(mean, stdDev, z)
  }
}
