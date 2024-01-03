import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_trusted_device_v2_channel.dart';

abstract class FlutterTrustedDeviceV2PlatformInterface extends PlatformInterface {
  /// Constructs a FlutterTrustedDeviceV2Platform.
  FlutterTrustedDeviceV2PlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static FlutterTrustedDeviceV2PlatformInterface _instance = FlutterTrustedDeviceV2Channel();

  /// The default instance of [FlutterTrustedDeviceV2PlatformInterface] to use.
  ///
  /// Defaults to [MethodChannelFlutterTrustedDeviceV2].
  static FlutterTrustedDeviceV2PlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTrustedDeviceV2PlatformInterface] when
  /// they register themselves.
  static set instance(FlutterTrustedDeviceV2PlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes this library.
  ///
  /// Mandatory function which you have to call before calling any Fazpass function.
  /// Not doing so might result in unexpected thrown exception.
  /// Call this method in onCreate method inside your default activity.
  /// For your public key which you get after contacting fazpass:
  /// - Android: put the public key in your assets folder.
  /// - iOS: Reference the public key in your project assets as data asset.
  ///
  /// Params:
  /// 1. [androidAssetName] | ANDROID ONLY | Your public key file name which you put in your src 'assets' folder. (Example: "public_key.pub").
  /// 2. [iosAssetName] | IOS ONLY | Your public key asset reference in your Xcode project assets (Example: "FazpassPublicKey").
  /// 3. [iosFcmAppId] | IOS ONLY | FCM App Id you get from fazpass after submitting your apple push notifications key.
  Future<void> init({String? androidAssetName, String? iosAssetName, String? iosFcmAppId});

  /// Collects specific information and generate meta data from it as Base64 string.
  ///
  /// You can use this meta to hit Fazpass API endpoint. Will launch biometric authentication before
  /// generating meta. Will apply settings that have been set in method [setSettingsForAccountIndex].
  /// Result will be empty string if exception is present.
  ///
  /// Params:
  /// 1. [accountIndex] Apply settings for this account index if settings have been set. Default to -1.
  ///
  /// Returns Base64 string or throws fazpass error.
  Future<String> generateMeta({int accountIndex=-1});

  /// Before generating meta with "High Level Biometric" settings, You have to generate secret key first by
  /// calling this method. This secret key will be invalidated when there is a new biometric enrolled or all
  /// biometric is cleared, which makes your active fazpass id to get revoked when you hit Fazpass Check API
  /// using meta generated with "High Level Biometric" settings. When secret key has been invalidated, you have
  /// to call this method to generate new secret key and enroll your device with Fazpass Enroll API to make
  /// your device trusted again.
  ///
  /// Might throws exception when generating new secret key. Report this exception as a bug when
  /// this method throws.
  Future<void> generateSecretKeyForHighLevelBiometric();

  Future<void> setSettingsForAccountIndex(int accountIndex, FazpassSettings? settings);

  Future<FazpassSettings?> getSettingsForAccountIndex(int accountIndex);

  Stream<CrossDeviceRequest> getCrossDeviceRequestStreamInstance();

  Future<CrossDeviceRequest?> getCrossDeviceRequestFromNotification();
}
