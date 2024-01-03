import Flutter
import UIKit
import ios_trusted_device_v2

public class FlutterTrustedDeviceV2Plugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_trusted_device_v2", binaryMessenger: registrar.messenger())
        let crossDeviceEvent = FlutterEventChannel(name: "flutter_trusted_device_v2_cd_request", binaryMessenger: registrar.messenger())
        let instance = FlutterTrustedDeviceV2Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        crossDeviceEvent.setStreamHandler(CrossDeviceEventHandler())
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            let args = call.arguments as! Dictionary<String, Any>
            Fazpass.shared.`init`(publicAssetName: args["assetName"] as! String, application: UIApplication.shared, fcmAppId: args["fcmAppId"] as! String)
            result(nil)
        case "generateMeta":
            let accountIndex = call.arguments as! Int
            Fazpass.shared.generateMeta(accountIndex: accountIndex) { meta, fazpassError in
                guard fazpassError != nil else {
                    result(meta)
                    return
                }
                
                switch (fazpassError!) {
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
                }
            }
        case "generateSecretKeyForHighLevelBiometric":
            do {
                try Fazpass.shared.generateSecretKeyForHighLevelBiometric()
                result(nil)
            } catch {
                result(FlutterError(code: "fazpassE-Error", message: error.localizedDescription, details: nil))
            }
        case "getSettingsForAccountIndex":
            let accountIndex = call.arguments as! Int
            let settings = Fazpass.shared.getFazpassSettingsForAccountIndex(accountIndex: accountIndex)
            result(settings?.toString())
        case "setSettingsForAccountIndex":
            let args = call.arguments as! Dictionary<String, Any>
            var settings: FazpassSettings?
            if (args["settings"] is String) {
                settings = FazpassSettings.fromString(args["String"] as! String)
            }
            Fazpass.shared.setFazpassSettingsForAccountIndex(accountIndex: args["accountIndex"] as! Int, settings: settings)
            result(nil)
        case "getCrossDeviceRequestFromNotification":
            let request = Fazpass.shared.getCrossDeviceRequestFromNotification()
            result(request?.toDict())
        default:
          result(FlutterMethodNotImplemented)
        }
    }
    
    class CrossDeviceEventHandler: NSObject, FlutterStreamHandler {
        
        private let stream = Fazpass.shared.getCrossDeviceRequestStreamInstance()
        
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            stream.listen { request in
                events(request.toDict())
            }
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            stream.close()
            return nil
        }
        
        
    }
}

extension CrossDeviceRequest {
    func toDict() -> [String: Any] {
        return [
            "merchant_app_id": self.merchantAppId,
            "expired": self.expired,
            "device_receive": self.deviceReceive,
            "device_request": self.deviceRequest,
            "device_id_receive": self.deviceIdReceive,
            "device_id_request": self.deviceIdRequest
        ]
    }
}
