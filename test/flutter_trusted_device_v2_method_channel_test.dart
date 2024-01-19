import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device_v2/src/flutter_trusted_device_v2_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FlutterTrustedDeviceV2Channel platform = FlutterTrustedDeviceV2Channel();
  MethodChannel? channel;

  bool isInitialized = false;

  setUp(() {
    isInitialized = false;

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
        }
        return null;
      },
    );
  });

  tearDown(() {
    isInitialized = false;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel!, null);
    channel = null;
  });

  test('init', () async {
    expectLater(() async => await platform.init(androidAssetName: 'wrongPath/asset'), throwsA(isA<Exception>()));
    expect(isInitialized, false);
    await platform.init(androidAssetName: 'rightPath/asset');
    expect(isInitialized, true);
  });

  test('generate meta', () async {
    expectLater(await platform.generateMeta(), 'meta');
  });
}
