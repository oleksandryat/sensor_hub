package com.sensorhub.sensorhub_native

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class AccelerometerStreamHandler(private val context: Context) :
  EventChannel.StreamHandler, SensorEventListener {
  private var manager: SensorManager? = null
  private var sink: EventChannel.EventSink? = null

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    if (sensor == null) {
      events.error("unavailable", "No accelerometer on this device", null)
      return
    }
    val hz = ((arguments as? Map<*, *>)?.get("samplingHz") as? Int)?.takeIf { it > 0 } ?: 50
    manager = sensorManager
    sink = events
    // No Handler means delivery on the main looper, which EventSink requires.
    sensorManager.registerListener(this, sensor, 1_000_000 / hz)
  }

  override fun onCancel(arguments: Any?) {
    manager?.unregisterListener(this)
    manager = null
    sink = null
  }

  override fun onSensorChanged(event: SensorEvent) {
    sink?.success(
      mapOf(
        "x" to event.values[0].toDouble(),
        "y" to event.values[1].toDouble(),
        "z" to event.values[2].toDouble(),
        "timestamp" to System.currentTimeMillis(),
      )
    )
  }

  override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
