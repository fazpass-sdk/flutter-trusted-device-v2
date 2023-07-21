import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trusted_device_v2/src/sensitive_data.dart';

import 'flutter_trusted_device_v2_platform_interface.dart';

/// An implementation of [FlutterTrustedDeviceV2Platform] that uses method channels.
class MethodChannelFlutterTrustedDeviceV2 extends FlutterTrustedDeviceV2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_trusted_device_v2');

  @override
  Future<void> init(String assetName) {
   return methodChannel.invokeMethod('init', assetName);
  }

  @override
  Future<String?> generateMeta() {
    return methodChannel.invokeMethod<String>('generateMeta');
  }

  @override
  Future<void> enableSelected(List<SensitiveData> sensitiveData) {
    return methodChannel.invokeMethod('enableSelected', sensitiveData.map((e) => e.name).toList());
  }
}
