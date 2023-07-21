import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_trusted_device_v2_method_channel.dart';

abstract class FlutterTrustedDeviceV2Platform extends PlatformInterface {
  /// Constructs a FlutterTrustedDeviceV2Platform.
  FlutterTrustedDeviceV2Platform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTrustedDeviceV2Platform _instance = MethodChannelFlutterTrustedDeviceV2();

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

  Future<void> init(String assetName);

  Future<String?> generateMeta();

  Future<void> enableSelected(List<SensitiveData> sensitiveData);
}
