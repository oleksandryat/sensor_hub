import UIKit

final class DeviceInfoHandler: DeviceInfoApi {
  func getDeviceInfo() throws -> DeviceInfoMessage {
    let device = UIDevice.current
    return DeviceInfoMessage(
      platform: "iOS",
      manufacturer: "Apple",
      model: device.model,
      osVersion: "\(device.systemName) \(device.systemVersion)"
    )
  }
}
