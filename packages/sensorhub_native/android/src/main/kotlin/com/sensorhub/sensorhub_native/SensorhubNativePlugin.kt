package com.sensorhub.sensorhub_native

import android.app.Activity
import android.content.Intent
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SensorhubNativePlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var accelerometerChannel: EventChannel

  // Null while the plugin is detached from an Activity (e.g. background engine).
  private var activity: Activity? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "sensorhub_native")
    channel.setMethodCallHandler(this)
    accelerometerChannel = EventChannel(binding.binaryMessenger, "sensorhub_native/accelerometer")
    accelerometerChannel.setStreamHandler(AccelerometerStreamHandler(binding.applicationContext))
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    accelerometerChannel.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getDeviceInfo" -> result.success(
        mapOf(
          "platform" to "Android",
          "manufacturer" to Build.MANUFACTURER,
          "model" to Build.MODEL,
          "osVersion" to "Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})",
        )
      )
      "shareText" -> shareText(call, result)
      else -> result.notImplemented()
    }
  }

  private fun shareText(call: MethodCall, result: Result) {
    val text = call.argument<String>("text")
    if (text.isNullOrEmpty()) {
      result.error("invalid_arguments", "text must not be empty", null)
      return
    }
    val current = activity
    if (current == null) {
      result.error("no_activity", "No foreground activity to present the share sheet", null)
      return
    }
    val send = Intent(Intent.ACTION_SEND).apply {
      type = "text/plain"
      putExtra(Intent.EXTRA_TEXT, text)
      call.argument<String>("subject")?.let { putExtra(Intent.EXTRA_SUBJECT, it) }
    }
    current.startActivity(Intent.createChooser(send, null))
    // ACTION_SEND gives no completion callback, so only the launch is known.
    result.success("launched")
  }
}
