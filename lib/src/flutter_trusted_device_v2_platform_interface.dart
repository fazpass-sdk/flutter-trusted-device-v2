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
  /// Defaults to [FlutterTrustedDeviceV2Channel].
  static FlutterTrustedDeviceV2PlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTrustedDeviceV2PlatformInterface] when
  /// they register themselves.
  static set instance(FlutterTrustedDeviceV2PlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes everything.
  ///
  /// Required to be called once at the start of application, otherwise
  /// unexpected error may occur.
  /// For Android, put the public key in your assets folder,
  /// then fill the [androidAssetName] with your file's name (Example: "public_key.pub").
  /// For iOS, reference the public key in your XCode project assets as data set,
  /// then fill the [iosAssetName] with your asset's name (Example: "FazpassPublicKey").
  /// Finally, fill the [iosFcmAppId] with FCM App ID that you get from fazpass
  /// after submitting your apple push notifications key.
  ///
  /// If your application only targets specific platform (Android only / iOS only),
  /// you can fill the unused platform's parameter with null.
  Future<void> init({String? androidAssetName, String? iosAssetName, String? iosFcmAppId});

  /// Collects specific data according to settings and generate meta from it as Base64 string.
  ///
  /// You can use this meta to hit Fazpass API endpoint. Calling this method will automatically launch
  /// local authentication (biometric / password). Any rules that have been set in method [Fazpass.setSettings]
  /// will be applied according to the [accountIndex] parameter.
  ///
  /// Throws any [FazpassException] if an error occurred.
  Future<String> generateMeta({int accountIndex=-1});

  /// Generates new secret key for high level biometric settings.
  ///
  /// Before generating meta with "High Level Biometric" settings, You have to generate secret key first by
  /// calling this method. This secret key will be invalidated when there is a new biometric enrolled or all
  /// biometric is cleared, which makes your active fazpass id to get revoked when you hit Fazpass Check API
  /// using meta generated with "High Level Biometric" settings. When secret key has been invalidated, you have
  /// to call this method to generate new secret key and enroll your device with Fazpass Enroll API to make
  /// your device trusted again.
  ///
  /// Might throws exception when generating new secret key. Report this exception as a bug when that happens.
  Future<void> generateNewSecretKey();

  /// Sets rules for data collection in [Fazpass.generateMeta] method.
  ///
  /// Sets which sensitive information is collected in [Fazpass.generateMeta] method
  /// and applies them according to [accountIndex] parameter. Accepts [FazpassSettings] for [settings]
  /// parameter. Settings will be stored in SharedPreferences (UserDefaults in iOS), so it will
  /// not persist when application data is cleared / application is uninstalled. To delete
  /// stored settings, pass null on [settings] parameter.
  Future<void> setSettings(int accountIndex, FazpassSettings? settings);

  /// Retrieves the rules that has been set in [Fazpass.setSettings] method.
  ///
  /// Retrieves a stored [FazpassSettings] object based on the [accountIndex] parameter.
  /// Returns null if there is no stored settings for this [accountIndex].
  Future<FazpassSettings?> getSettings(int accountIndex);

  /// Retrieves the stream instance of cross device notification data.
  Stream<CrossDeviceData> getCrossDeviceDataStreamInstance();

  /// Retrieves a [CrossDeviceData] object obtained from notification.
  ///
  /// If user launched the application from notification, this method will return data
  /// contained in that notification. Will return null if user launched the application
  /// normally.
  Future<CrossDeviceData?> getCrossDeviceDataFromNotification();

  /// Retrieves application signatures.
  ///
  /// Only works in android. Will return empty list in iOS.
  Future<List<String>> getAppSignatures();
}
