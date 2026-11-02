package com.sensorhub.sensorhub_native

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/// Custom-drawn arc gauge; the value is clamped to [min, max].
class GaugeView(context: Context, private val min: Double, private val max: Double, private val unit: String, value: Double) : View(context) {
  private val density = resources.displayMetrics.density
  private val track = Paint(Paint.ANTI_ALIAS_FLAG).apply {
    style = Paint.Style.STROKE
    strokeCap = Paint.Cap.ROUND
    strokeWidth = 14 * density
    color = 0x33808080
  }
  private val arc = Paint(track).apply { color = 0xFF2E7D32.toInt() }
  private val text = Paint(Paint.ANTI_ALIAS_FLAG).apply {
    textAlign = Paint.Align.CENTER
    color = 0xFF808080.toInt()
  }
  private val bounds = RectF()

  var value: Double = value.coerceIn(min, max)
    set(newValue) {
      field = newValue.coerceIn(min, max)
      invalidate()
    }

  override fun onDraw(canvas: Canvas) {
    val size = minOf(width, height).toFloat()
    val inset = track.strokeWidth
    bounds.set(
      (width - size) / 2 + inset, (height - size) / 2 + inset,
      (width + size) / 2 - inset, (height + size) / 2 - inset,
    )
    // 270° sweep starting at the lower left.
    val fraction = if (max > min) ((value - min) / (max - min)).toFloat() else 0f
    canvas.drawArc(bounds, 135f, 270f, false, track)
    canvas.drawArc(bounds, 135f, 270f * fraction, false, arc)
    text.textSize = size / 5
    canvas.drawText("%.1f".format(value), width / 2f, height / 2f, text)
    text.textSize = size / 12
    canvas.drawText(unit, width / 2f, height / 2f + size / 7, text)
  }
}

class GaugePlatformView(context: Context, messenger: BinaryMessenger, viewId: Int, params: Map<*, *>) : PlatformView {
  private val gauge = GaugeView(
    context,
    (params["min"] as Number).toDouble(),
    (params["max"] as Number).toDouble(),
    params["unit"] as String,
    (params["value"] as Number).toDouble(),
  )

  // One channel per view, so updates reach the right instance.
  private val channel = MethodChannel(messenger, "sensorhub_native/gauge_$viewId").apply {
    setMethodCallHandler { call, result ->
      if (call.method == "setValue") {
        gauge.value = (call.arguments as Number).toDouble()
        result.success(null)
      } else {
        result.notImplemented()
      }
    }
  }

  override fun getView(): View = gauge

  override fun dispose() = channel.setMethodCallHandler(null)
}

class GaugeViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView =
    GaugePlatformView(context, messenger, viewId, args as Map<*, *>)
}
