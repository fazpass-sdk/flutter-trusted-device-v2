
import 'sensitive_data.dart';
import 'flutter_trusted_device_v2_platform_interface.dart';

class Fazpass implements FlutterTrustedDeviceV2Platform {

  static final instance = Fazpass._();
  Fazpass._();

  @override
  Future<void> init(String assetName) {
    return FlutterTrustedDeviceV2Platform.instance.init(assetName);
  }

  @override
  Future<String> generateMeta() {
    return FlutterTrustedDeviceV2Platform.instance.generateMeta();
  }

  @override
  Future<void> enableSelected(List<SensitiveData> sensitiveData) {
    return FlutterTrustedDeviceV2Platform.instance.enableSelected(sensitiveData);
  }
}
