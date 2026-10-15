import Flutter
import UIKit

public class SensorhubNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sensorhub_native", binaryMessenger: registrar.messenger())
    let instance = SensorhubNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let accelerometer = FlutterEventChannel(name: "sensorhub_native/accelerometer", binaryMessenger: registrar.messenger())
    accelerometer.setStreamHandler(AccelerometerStreamHandler())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDeviceInfo":
      let device = UIDevice.current
      result([
        "platform": "iOS",
        "manufacturer": "Apple",
        "model": device.model,
        "osVersion": "\(device.systemName) \(device.systemVersion)",
      ])
    case "shareText":
      shareText(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func shareText(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    guard let text = args?["text"] as? String, !text.isEmpty else {
      result(FlutterError(code: "invalid_arguments", message: "text must not be empty", details: nil))
      return
    }
    guard let presenter = Self.topViewController() else {
      result(FlutterError(code: "no_activity", message: "No view controller to present the share sheet", details: nil))
      return
    }
    let sheet = UIActivityViewController(activityItems: [text], applicationActivities: nil)
    if let subject = args?["subject"] as? String {
      sheet.setValue(subject, forKey: "subject")
    }
    // Resolved only after the user finishes or dismisses the sheet.
    sheet.completionWithItemsHandler = { _, completed, _, _ in
      result(completed ? "completed" : "dismissed")
    }
    // iPad presents the sheet as a popover and crashes without an anchor.
    if let popover = sheet.popoverPresentationController {
      popover.sourceView = presenter.view
      popover.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
      popover.permittedArrowDirections = []
    }
    presenter.present(sheet, animated: true)
  }

  private static func topViewController() -> UIViewController? {
    let scene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }
    var top = scene?.windows.first { $0.isKeyWindow }?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
}
