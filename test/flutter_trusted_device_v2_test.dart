import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:flutter_trusted_device_v2/src/flutter_trusted_device_v2_method_channel.dart';
import 'package:flutter_trusted_device_v2/src/flutter_trusted_device_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTrustedDeviceV2Platform
    with MockPlatformInterfaceMixin
    implements FlutterTrustedDeviceV2Platform {

  @override
  Future<void> enableSelected(List<SensitiveData> sensitiveData) async {
    return;
  }

  @override
  Future<String?> generateMeta() => Future.value('meta');

  @override
  Future<void> init(String assetName) async {
    if (assetName != 'rightPath/asset') throw Exception('path not found!');
    return;
  }
}

void main() {

  test('$MethodChannelFlutterTrustedDeviceV2 is the default instance', () {
    final FlutterTrustedDeviceV2Platform initialPlatform = FlutterTrustedDeviceV2Platform.instance;
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTrustedDeviceV2>());
  });

  group('Fazpass methods test', () {

    setUp(() {
      MockFlutterTrustedDeviceV2Platform fakePlatform = MockFlutterTrustedDeviceV2Platform();
      FlutterTrustedDeviceV2Platform.instance = fakePlatform;
    });

    tearDown(() {
      FlutterTrustedDeviceV2Platform.instance = MethodChannelFlutterTrustedDeviceV2();
    });

    test('init', () async {
      expect(() => Fazpass.instance.init('wrongPath/asset'), throwsA(isA<Exception>()));
    });

    test('generate meta', () async {
      expectLater(await Fazpass.instance.generateMeta(), 'meta');
    });

    test('enable selected', () async {
      expect(() => Fazpass.instance.enableSelected([]), isA<void>());
    });
  });
}
