import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:flutter_trusted_device_v2/src/flutter_trusted_device_v2_channel.dart';
import 'package:flutter_trusted_device_v2/src/flutter_trusted_device_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTrustedDeviceV2Platform
    with MockPlatformInterfaceMixin
    implements FlutterTrustedDeviceV2PlatformInterface {

  @override
  Future<void> init({String? androidAssetName, String? iosAssetName, String? iosFcmAppId}) async {
    if (androidAssetName != 'rightPath/asset') throw Exception('path not found!');
    return;
  }

  @override
  Future<String> generateMeta({int accountIndex=-1}) => Future.value('meta');

  @override
  Future<void> generateNewSecretKey() {
    // TODO: implement generateSecretKeyForHighLevelBiometric
    throw UnimplementedError();
  }

  @override
  Future<FazpassSettings?> getSettings(int accountIndex) {
    // TODO: implement getSettingsForAccountIndex
    throw UnimplementedError();
  }

  @override
  Future<void> setSettings(int accountIndex, FazpassSettings? settings) async {
    FazpassSettingsBuilder();
    return;
  }

  @override
  Stream<CrossDeviceData> getCrossDeviceDataStreamInstance() => const Stream.empty();

  @override
  Future<CrossDeviceData?> getCrossDeviceDataFromNotification() => Future.value(null);

  @override
  Future<List<String>> getAppSignatures() {
    // TODO: implement getAppSignatures
    throw UnimplementedError();
  }
}

void main() {

  test('$FlutterTrustedDeviceV2Channel is the default instance', () {
    final FlutterTrustedDeviceV2PlatformInterface initialPlatform = FlutterTrustedDeviceV2PlatformInterface.instance;
    expect(initialPlatform, isInstanceOf<FlutterTrustedDeviceV2Channel>());
  });

  group('Fazpass methods test', () {

    setUp(() {
      MockFlutterTrustedDeviceV2Platform fakePlatform = MockFlutterTrustedDeviceV2Platform();
      FlutterTrustedDeviceV2PlatformInterface.instance = fakePlatform;
    });

    tearDown(() {
      FlutterTrustedDeviceV2PlatformInterface.instance = FlutterTrustedDeviceV2Channel();
    });

    test('init', () async {
      expect(() => Fazpass.instance.init(androidAssetName: 'wrongPath/asset'), throwsA(isA<Exception>()));
    });

    test('generate meta', () async {
      expectLater(await Fazpass.instance.generateMeta(), 'meta');
    });
  });
}
