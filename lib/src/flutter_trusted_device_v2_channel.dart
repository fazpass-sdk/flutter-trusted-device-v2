import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trusted_device_v2/src/cross_device_request.dart';
import 'package:flutter_trusted_device_v2/src/fazpass_exception.dart';
import 'package:flutter_trusted_device_v2/src/fazpass_settings.dart';

import 'flutter_trusted_device_v2_platform_interface.dart';

/// An implementation of [FlutterTrustedDeviceV2PlatformInterface] that uses method channels.
class FlutterTrustedDeviceV2Channel extends FlutterTrustedDeviceV2PlatformInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_trusted_device_v2');
  @visibleForTesting
  final eventChannel = const EventChannel('flutter_trusted_device_v2_cd_request');

  @override
  Future<void> init({String? androidAssetName, String? iosAssetName, String? iosFcmAppId}) async {
    if (Platform.isAndroid) {
      return methodChannel.invokeMethod('init', androidAssetName);
    } else if (Platform.isIOS) {
      return methodChannel.invokeMethod('init', {"assetName": iosAssetName, "fcmAppId": iosFcmAppId});
    }
    return;
  }

  @override
  Future<String> generateMeta({int accountIndex=-1}) async {
    String meta = '';
    try {
      meta = await methodChannel.invokeMethod<String>('generateMeta', accountIndex) ?? '';
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
        case 'fazpassE-publicKeyNotExist':
          throw PublicKeyNotExistException(e);
        case 'fazpassE-uninitialized':
          throw UninitializedException(e);
        case 'fazpassE-biometricSecurityUpdateRequired':
          throw BiometricSecurityUpdateRequiredError(e);
        case 'fazpassE-encryptionError':
        default:
          throw EncryptionException(e);
      }
    }
    return meta;
  }

  @override
  Future<void> generateNewSecretKey() async {
    return methodChannel.invokeMethod('generateSecretKeyForHighLevelBiometric');
  }

  @override
  Future<FazpassSettings?> getSettings(int accountIndex) async {
    final settingsString = await methodChannel.invokeMethod('getSettingsForAccountIndex', accountIndex);
    if (settingsString is String) {
      return FazpassSettings.fromString(settingsString);
    }
    return null;
  }

  @override
  Future<void> setSettings(int accountIndex, FazpassSettings? settings) async {
    return await methodChannel.invokeMethod('setSettingsForAccountIndex', {"accountIndex": accountIndex, "settings": settings?.toString()});
  }

  @override
  Stream<CrossDeviceRequest> getCrossDeviceRequestStreamInstance() {
    return eventChannel.receiveBroadcastStream().map((event) => CrossDeviceRequest.fromData(event));
  }

  @override
  Future<CrossDeviceRequest?> getCrossDeviceRequestFromNotification() async {
    final data = await methodChannel.invokeMethod('getCrossDeviceRequestFromNotification');
    return data == null ? null : CrossDeviceRequest.fromData(data);
  }

  @override
  Future<List<String>> getAppSignatures() async {
    if (Platform.isAndroid) {
      final signatures = await methodChannel.invokeListMethod<String>('helper:getAppSignatures');
      return signatures ?? [];
    }

    return [];
  }
}
