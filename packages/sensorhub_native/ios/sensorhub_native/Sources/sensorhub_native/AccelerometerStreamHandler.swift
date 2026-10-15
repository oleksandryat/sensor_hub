import CoreMotion
import Flutter

final class AccelerometerStreamHandler: NSObject, FlutterStreamHandler {
  private static let gravity = 9.80665

  private let motion = CMMotionManager()

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard motion.isAccelerometerAvailable else {
      return FlutterError(code: "unavailable", message: "No accelerometer on this device", details: nil)
    }
    let requested = (arguments as? [String: Any])?["samplingHz"] as? Int ?? 50
    motion.accelerometerUpdateInterval = 1.0 / Double(max(requested, 1))
    // The main queue keeps delivery on the platform thread, as FlutterEventSink requires.
    motion.startAccelerometerUpdates(to: .main) { data, error in
      if let error = error {
        events(FlutterError(code: "sensor_error", message: error.localizedDescription, details: nil))
        return
      }
      guard let a = data?.acceleration else { return }
      // CoreMotion reports g with the opposite sign to Android; convert to m/s² in Android's convention.
      let k = -Self.gravity
      events([
        "x": a.x * k,
        "y": a.y * k,
        "z": a.z * k,
        "timestamp": Int(Date().timeIntervalSince1970 * 1000),
      ])
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    motion.stopAccelerometerUpdates()
    return nil
  }
}
