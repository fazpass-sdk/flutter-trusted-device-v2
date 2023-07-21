// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('generateMeta test', (WidgetTester tester) async {
    final Fazpass plugin = Fazpass.instance;
    final String? meta = await plugin.generateMeta();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(meta?.isNotEmpty, true);
  });
}
