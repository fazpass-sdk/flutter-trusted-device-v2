import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:flutter_trusted_device_v2/src/flutter_trusted_device_v2_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterTrustedDeviceV2 platform = MethodChannelFlutterTrustedDeviceV2();
  MethodChannel? channel;

  bool isInitialized = false;
  bool isLocationEnabled = false;

  setUp(() {
    isInitialized = false;
    isLocationEnabled = false;

    channel = platform.methodChannel;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel!,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'init':
            var arguments = methodCall.arguments as String;
            if (arguments == 'rightPath/asset') {
              isInitialized = true;
            } else {
              throw Exception();
            }
            break;
          case 'generateMeta':
            return 'meta';
          case 'enableSelected':
            var arguments = methodCall.arguments as List<Object?>;
            if (arguments.contains(SensitiveData.location.name)) {
              isLocationEnabled = true;
            }
            break;
        }
        return null;
      },
    );
  });

  tearDown(() {
    isInitialized = false;
    isLocationEnabled = false;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel!, null);
    channel = null;
  });

  test('init', () async {
    expectLater(() async => await platform.init('wrongPath/asset'), throwsA(isA<Exception>()));
    expect(isInitialized, false);
    await platform.init('rightPath/asset');
    expect(isInitialized, true);
  });

  test('generate meta', () async {
    expectLater(await platform.generateMeta(), 'meta');
  });

  test('enable selected', () async {
    expect(isLocationEnabled, false);
    await platform.enableSelected([SensitiveData.location]);
    expect(isLocationEnabled, true);
  });
}
