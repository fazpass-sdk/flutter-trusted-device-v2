import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_trusted_device_v2_channel.dart';

abstract class FlutterTrustedDeviceV2Platform extends PlatformInterface {
  /// Constructs a FlutterTrustedDeviceV2Platform.
  FlutterTrustedDeviceV2Platform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTrustedDeviceV2Platform _instance = ChannelFlutterTrustedDeviceV2();

  /// The default instance of [FlutterTrustedDeviceV2Platform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTrustedDeviceV2].
  static FlutterTrustedDeviceV2Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTrustedDeviceV2Platform] when
  /// they register themselves.
  static set instance(FlutterTrustedDeviceV2Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Mandatory function which you have to call before calling any Fazpass function.
  /// Not doing so might result in unexpected thrown exception. For your public key which you
  /// get after contacting fazpass, put it in your assets folder.
  /// On android, write it's name with it's extension (public_key.pub).
  Future<void> init(String assetName);

  /// Collect specific information and generate meta data from it as Base64 string.
  /// You can use this meta to hit Fazpass API endpoint. Will launch biometric authentication before
  /// generating meta. This future may produce error if biometric authentication failed or encryption error.
  Future<String> generateMeta();

  /// Sensitive data requires the user to grant certain permissions so it could be collected.
  /// All sensitive data collection is disabled by default, which means you have to enable each of
  /// them manually. Before enabling any sensitive data collection, however, you have to request
  /// the required permissions first. Until their required permissions is granted, sensitive data won't
  /// be collected even if they have been enabled. Required permissions for each sensitive data has been
  /// listed in [SensitiveData] member's documentation.
  ///
  /// You can include any sensitive data you want to enable in [sensitiveData] parameter.
  Future<void> enableSelected(List<SensitiveData> sensitiveData);

  Stream<CrossDeviceRequest> getCrossDeviceRequestStreamInstance();

  Future<CrossDeviceRequest?> getCrossDeviceRequestFromIntent();
}
