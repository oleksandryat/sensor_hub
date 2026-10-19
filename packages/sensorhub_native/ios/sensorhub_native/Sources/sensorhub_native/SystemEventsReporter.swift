import Flutter
import UIKit

/// Pushes memory warnings and foreground/background changes to Dart.
final class SystemEventsReporter {
  private let channel: FlutterBasicMessageChannel
  private var observers: [NSObjectProtocol] = []

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterBasicMessageChannel(
      name: "sensorhub_native/system_events",
      binaryMessenger: messenger,
      codec: FlutterJSONMessageCodec.sharedInstance()
    )
    let center = NotificationCenter.default
    // UIApplication posts these on the main thread, which channel.sendMessage requires.
    observers = [
      center.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: .main) {
        [weak self] _ in
        self?.send(["type": "memory", "level": "critical", "source": "didReceiveMemoryWarning"])
      },
      center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) {
        [weak self] _ in
        self?.send(["type": "lifecycle", "state": "background"])
      },
      center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) {
        [weak self] _ in
        self?.send(["type": "lifecycle", "state": "foreground"])
      },
    ]
  }

  deinit {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
  }

  private func send(_ event: [String: Any]) {
    var message = event
    message["timestamp"] = Int(Date().timeIntervalSince1970 * 1000)
    channel.sendMessage(message)
  }
}

/// Echo channels for measuring round-trip latency per codec.
enum PingHandlers {
  static func register(messenger: FlutterBinaryMessenger) {
    let codecs: [(String, FlutterMessageCodec & NSObjectProtocol)] = [
      ("sensorhub_native/ping/json", FlutterJSONMessageCodec.sharedInstance()),
      ("sensorhub_native/ping/standard", FlutterStandardMessageCodec.sharedInstance()),
    ]
    for (name, codec) in codecs {
      FlutterBasicMessageChannel(name: name, binaryMessenger: messenger, codec: codec)
        .setMessageHandler { message, reply in reply(message) }
    }
  }
}
