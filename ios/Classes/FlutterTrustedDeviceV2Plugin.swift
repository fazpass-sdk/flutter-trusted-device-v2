import Flutter
import UIKit
import ios_trusted_device_v2

public class FlutterTrustedDeviceV2Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_trusted_device_v2", binaryMessenger: registrar.messenger())
    let instance = FlutterTrustedDeviceV2Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
        let assetName = call.arguments as! String
        Fazpass.shared.`init`(assetName: assetName)
        result(nil)
    case "generateMeta":
        Task {
            await Fazpass.shared.generateMeta { meta in
                result(meta)
            }
        }
    case "enableSelected":
        let args = call.arguments as! Array<String>
        for arg in args {
            if let sensitiveData = SensitiveData(rawValue: arg) {
                Fazpass.shared.enableSelected(sensitiveData)
            }
        }
        result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
