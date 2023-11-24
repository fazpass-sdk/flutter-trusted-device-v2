import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trusted_device_v2/src/cross_device_request.dart';
import 'package:flutter_trusted_device_v2/src/fazpass_exception.dart';
import 'package:flutter_trusted_device_v2/src/sensitive_data.dart';

import 'flutter_trusted_device_v2_platform_interface.dart';

/// An implementation of [FlutterTrustedDeviceV2Platform] that uses method channels.
class ChannelFlutterTrustedDeviceV2 extends FlutterTrustedDeviceV2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_trusted_device_v2');
  @visibleForTesting
  final eventChannel = const EventChannel('flutter_trusted_device_v2_cd_request');

  @override
  Future<void> init(String assetName) {
   return methodChannel.invokeMethod('init', assetName);
  }

  @override
  Future<String> generateMeta() async {
    String meta = '';
    try {
      meta = await methodChannel.invokeMethod<String>('generateMeta') ?? '';
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'fazpassE-biometricNoneEnrolled':
          throw BiometricNoneEnrolledError(e);
        case 'fazpassE-biometricAuthFailed':
          throw BiometricAuthFailedError(e);
        case 'fazpassE-biometricUnavailable':
          throw BiometricUnavailableError(e);
        case 'fazpassE-biometricUnsupported':
          throw BiometricUnsupportedError(e);
        case 'fazpassE-encryptionError':
          throw EncryptionException(e);
        case 'fazpassE-publicKeyNotExist':
          throw PublicKeyNotExistException(e);
        case 'fazpassE-uninitialized':
          throw UninitializedException(e);
        case 'fazpassE-biometricSecurityUpdateRequired':
          throw BiometricSecurityUpdateRequiredError(e);
        default:
          throw UnknownError(e);
      }
    }
    return meta;
  }

  @override
  Future<void> enableSelected(List<SensitiveData> sensitiveData) {
    return methodChannel.invokeMethod('enableSelected', sensitiveData.map((e) => e.name).toList());
  }

  @override
  Stream<CrossDeviceRequest> getCrossDeviceRequestStreamInstance() {
    return eventChannel.receiveBroadcastStream().map((event) => CrossDeviceRequest.fromData(event));
  }

  @override
  Future<CrossDeviceRequest?> getCrossDeviceRequestFromIntent() async {
    final data = await methodChannel.invokeMethod('getCrossDeviceRequestFromFirstActivityIntent');
    return data == null ? null : CrossDeviceRequest.fromData(data);
  }
}
