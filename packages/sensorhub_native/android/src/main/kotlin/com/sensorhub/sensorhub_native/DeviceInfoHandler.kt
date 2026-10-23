package com.sensorhub.sensorhub_native

import android.os.Build

class DeviceInfoHandler : DeviceInfoApi {
  override fun getDeviceInfo() = DeviceInfoMessage(
    platform = "Android",
    manufacturer = Build.MANUFACTURER,
    model = Build.MODEL,
    osVersion = "Android ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})",
  )
}
