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
        Fazpass.shared.`init`(publicAssetName: assetName)
        result(nil)
    case "generateMeta":
        Fazpass.shared.generateMeta { meta, fazpassError in
            guard let error = fazpassError else {
                result(meta)
                return
            }
            
            switch (error) {
            case .biometricNoneEnrolled:
                result(
                    FlutterError(
                        code: "fazpassE-biometricNoneEnrolled",
                        message: "Device can't start biometry authentication because there is no biometry (Touch ID or Face ID) or device passcode enrolled.",
                        details: nil
                    )
                )
            case .biometricAuthFailed:
                result(
                    FlutterError(
                        code: "fazpassE-biometricAuthFailed",
                        message: "Biometry authentication is finished with an error (e.g. User cancelled biometric auth, etc).",
                        details: nil
                    )
                )
            case .biometricNotAvailable:
                result(
                    FlutterError(
                        code: "fazpassE-biometricUnavailable",
                        message: "Device can't start biometry authentication because biometry is unavailable.",
                        details: nil
                    )
                )
            case .biometricNotInteractive:
                result(
                    FlutterError(
                        code: "fazpassE-biometricUnsupported",
                        message: "Device can't start biometry authentication because displaying the required authentication user interface is forbidden. To fix this, you have to permit the display of the authentication UI by setting the interactionNotAllowed property to false.",
                        details: nil
                    )
                )
            case .encryptionError(let message):
                result(
                    FlutterError(
                        code: "fazpassE-encryptionError",
                        message: "Encryption went wrong because you used the wrong public key. message: \(message)",
                        details: nil
                    )
                )
            case .publicKeyNotExist:
                result(
                    FlutterError(
                        code: "fazpassE-publicKeyNotExist",
                        message: "Public key with the name registered in init method doesn't exist as an asset.",
                        details: nil
                    )
                )
            case .uninitialized:
                result(
                    FlutterError(
                        code: "fazpassE-uninitialized",
                        message: "Fazpass init method hasn't been called once.",
                        details: nil
                    )
                )
            case .unknownError(let error):
                result(
                    FlutterError(
                        code: "fazpassE-unknown",
                        message: "\(error)",
                        details: nil
                    )
                )
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
