package com.sensorhub.sensorhub_native

import android.app.Activity
import android.app.Application
import android.content.ComponentCallbacks2
import android.content.Context
import android.content.res.Configuration
import android.os.Bundle
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.JSONMessageCodec
import org.json.JSONObject

/// Pushes memory pressure and foreground/background changes to Dart.
class SystemEventsReporter(messenger: BinaryMessenger, private val context: Context) :
  ComponentCallbacks2, Application.ActivityLifecycleCallbacks {
  private val channel =
    BasicMessageChannel(messenger, "sensorhub_native/system_events", JSONMessageCodec.INSTANCE)
  private var activity: Activity? = null
  private var foreground: Boolean? = null

  fun start() = context.registerComponentCallbacks(this)

  fun stop() {
    context.unregisterComponentCallbacks(this)
    detachActivity()
  }

  fun attachActivity(activity: Activity) {
    this.activity = activity
    activity.application.registerActivityLifecycleCallbacks(this)
  }

  fun detachActivity() {
    activity?.application?.unregisterActivityLifecycleCallbacks(this)
    activity = null
  }

  @Suppress("DEPRECATION")
  override fun onTrimMemory(level: Int) {
    val (pressure, source) = when (level) {
      // Visibility change only; lifecycle events already cover it.
      ComponentCallbacks2.TRIM_MEMORY_UI_HIDDEN -> return
      ComponentCallbacks2.TRIM_MEMORY_RUNNING_MODERATE -> "moderate" to "TRIM_MEMORY_RUNNING_MODERATE"
      ComponentCallbacks2.TRIM_MEMORY_RUNNING_LOW -> "critical" to "TRIM_MEMORY_RUNNING_LOW"
      ComponentCallbacks2.TRIM_MEMORY_RUNNING_CRITICAL -> "critical" to "TRIM_MEMORY_RUNNING_CRITICAL"
      ComponentCallbacks2.TRIM_MEMORY_BACKGROUND -> "moderate" to "TRIM_MEMORY_BACKGROUND"
      ComponentCallbacks2.TRIM_MEMORY_MODERATE -> "moderate" to "TRIM_MEMORY_MODERATE"
      ComponentCallbacks2.TRIM_MEMORY_COMPLETE -> "critical" to "TRIM_MEMORY_COMPLETE"
      else -> "moderate" to "TRIM_MEMORY_$level"
    }
    sendMemory(pressure, source)
  }

  @Deprecated("Deprecated in Java")
  override fun onLowMemory() = sendMemory("critical", "onLowMemory")

  override fun onConfigurationChanged(newConfig: Configuration) {}

  override fun onActivityStarted(activity: Activity) {
    if (activity === this.activity) sendLifecycle(true)
  }

  override fun onActivityStopped(activity: Activity) {
    // Rotation stops and recreates the Activity without leaving the foreground.
    if (activity === this.activity && !activity.isChangingConfigurations) sendLifecycle(false)
  }

  override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {}
  override fun onActivityResumed(activity: Activity) {}
  override fun onActivityPaused(activity: Activity) {}
  override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
  override fun onActivityDestroyed(activity: Activity) {}

  private fun sendMemory(level: String, source: String) = send(
    JSONObject().put("type", "memory").put("level", level).put("source", source)
  )

  // A recreated Activity starts again; only real transitions are reported.
  private fun sendLifecycle(isForeground: Boolean) {
    if (foreground == isForeground) return
    foreground = isForeground
    send(JSONObject().put("type", "lifecycle").put("state", if (isForeground) "foreground" else "background"))
  }

  // Callbacks run on the main thread, which BasicMessageChannel.send requires.
  private fun send(event: JSONObject) {
    channel.send(event.put("timestamp", System.currentTimeMillis()))
  }
}
