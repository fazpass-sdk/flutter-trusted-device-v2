
import 'package:flutter_trusted_device_v2/src/cross_device_data.dart';
import 'package:flutter_trusted_device_v2/src/fazpass_settings.dart';

import 'flutter_trusted_device_v2_platform_interface.dart';

class Fazpass implements FlutterTrustedDeviceV2PlatformInterface {

  static final instance = Fazpass._();
  Fazpass._();

  @override
  Future<void> init({String? androidAssetName, String? iosAssetName, String? iosFcmAppId}) {
    return FlutterTrustedDeviceV2PlatformInterface.instance.init(
      androidAssetName: androidAssetName,
      iosAssetName: iosAssetName,
      iosFcmAppId: iosFcmAppId
    );
  }

  @override
  Future<String> generateMeta({int accountIndex=-1}) {
    return FlutterTrustedDeviceV2PlatformInterface.instance.generateMeta(accountIndex: accountIndex);
  }

  @override
  Future<void> generateNewSecretKey() {
    return FlutterTrustedDeviceV2PlatformInterface.instance.generateNewSecretKey();
  }

  @override
  Future<FazpassSettings?> getSettings(int accountIndex) {
    return FlutterTrustedDeviceV2PlatformInterface.instance.getSettings(accountIndex);
  }

  @override
  Future<void> setSettings(int accountIndex, FazpassSettings? settings) {
    return FlutterTrustedDeviceV2PlatformInterface.instance.setSettings(accountIndex, settings);
  }

  @override
  Stream<CrossDeviceData> getCrossDeviceDataStreamInstance() {
    return FlutterTrustedDeviceV2PlatformInterface.instance.getCrossDeviceDataStreamInstance();
  }

  @override
  Future<CrossDeviceData?> getCrossDeviceDataFromNotification() {
    return FlutterTrustedDeviceV2PlatformInterface.instance.getCrossDeviceDataFromNotification();
  }

  @override
  Future<List<String>> getAppSignatures() {
    return FlutterTrustedDeviceV2PlatformInterface.instance.getAppSignatures();
  }
}
