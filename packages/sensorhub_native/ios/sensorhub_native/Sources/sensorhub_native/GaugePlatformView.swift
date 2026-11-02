import Flutter
import UIKit

/// Custom-drawn arc gauge; the value is clamped to [min, max].
final class GaugeUIView: UIView {
  private let min: Double
  private let max: Double
  private let unit: String
  private var value: Double

  init(min: Double, max: Double, unit: String, value: Double) {
    self.min = min
    self.max = max
    self.unit = unit
    self.value = Swift.min(Swift.max(value, min), max)
    super.init(frame: .zero)
    backgroundColor = .clear
    contentMode = .redraw
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

  func setValue(_ newValue: Double) {
    value = Swift.min(Swift.max(newValue, min), max)
    setNeedsDisplay()
  }

  override func draw(_ rect: CGRect) {
    let size = Swift.min(bounds.width, bounds.height)
    let lineWidth: CGFloat = 14
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = size / 2 - lineWidth
    // 270° sweep starting at the lower left (UIKit angles run clockwise).
    let start = CGFloat.pi * 3 / 4
    let sweep = CGFloat.pi * 3 / 2
    let fraction = max > min ? CGFloat((value - min) / (max - min)) : 0

    func stroke(_ end: CGFloat, _ color: UIColor) {
      let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
      path.lineWidth = lineWidth
      path.lineCapStyle = .round
      color.setStroke()
      path.stroke()
    }
    stroke(start + sweep, UIColor.gray.withAlphaComponent(0.2))
    if fraction > 0 { stroke(start + sweep * fraction, UIColor(red: 0.18, green: 0.49, blue: 0.2, alpha: 1)) }

    func draw(_ string: String, size fontSize: CGFloat, centerY: CGFloat) {
      let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: UIColor.gray]
      let textSize = string.size(withAttributes: attributes)
      string.draw(at: CGPoint(x: center.x - textSize.width / 2, y: centerY - textSize.height / 2), withAttributes: attributes)
    }
    draw(String(format: "%.1f", value), size: size / 5, centerY: center.y)
    draw(unit, size: size / 12, centerY: center.y + size / 7)
  }
}

final class GaugePlatformView: NSObject, FlutterPlatformView {
  private let gauge: GaugeUIView
  private let channel: FlutterMethodChannel

  init(frame: CGRect, viewId: Int64, params: [String: Any], messenger: FlutterBinaryMessenger) {
    gauge = GaugeUIView(
      min: params["min"] as? Double ?? 0,
      max: params["max"] as? Double ?? 1,
      unit: params["unit"] as? String ?? "",
      value: params["value"] as? Double ?? 0
    )
    gauge.frame = frame
    // One channel per view, so updates reach the right instance.
    channel = FlutterMethodChannel(name: "sensorhub_native/gauge_\(viewId)", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "setValue", let value = call.arguments as? Double {
        self?.gauge.setValue(value)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  func view() -> UIView { gauge }

  deinit { channel.setMethodCallHandler(nil) }
}

final class GaugeViewFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    GaugePlatformView(frame: frame, viewId: viewId, params: args as? [String: Any] ?? [:], messenger: messenger)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}
