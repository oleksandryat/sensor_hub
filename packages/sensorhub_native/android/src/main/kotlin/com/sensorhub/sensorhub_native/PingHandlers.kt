package com.sensorhub.sensorhub_native

import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.JSONMessageCodec
import io.flutter.plugin.common.StandardMessageCodec

/// Echo channels for measuring round-trip latency per codec.
object PingHandlers {
  private val channels = mapOf(
    "sensorhub_native/ping/json" to JSONMessageCodec.INSTANCE,
    "sensorhub_native/ping/standard" to StandardMessageCodec.INSTANCE,
  )

  fun register(messenger: BinaryMessenger) = channels.forEach { (name, codec) ->
    BasicMessageChannel(messenger, name, codec).setMessageHandler { message, reply -> reply.reply(message) }
  }

  fun unregister(messenger: BinaryMessenger) = channels.forEach { (name, codec) ->
    BasicMessageChannel(messenger, name, codec).setMessageHandler(null)
  }
}
