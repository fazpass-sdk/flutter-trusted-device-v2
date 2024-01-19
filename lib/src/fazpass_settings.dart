
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

import 'sensitive_data.dart';

class FazpassSettings {
  final List<SensitiveData> sensitiveData;
  final bool isBiometricLevelHigh;

  FazpassSettings._(this.sensitiveData, this.isBiometricLevelHigh);

  factory FazpassSettings.fromString(String settingsString) {
    final splitter = settingsString.split(";");
    final sensitiveData = splitter[0].split(",")
        .takeWhile((it) => it != "")
        .map((it) => SensitiveData.values.firstWhere((element) => element.name == it))
        .toList();
    final isBiometricLevelHigh = bool.tryParse(splitter[1]) ?? false;

    return FazpassSettings._(sensitiveData, isBiometricLevelHigh);
  }

  @override
  String toString() => "${sensitiveData.map((it) => it.name).join(",")};$isBiometricLevelHigh";
}

class FazpassSettingsBuilder {
  List<SensitiveData> sensitiveDataList;
  bool isBiometricLevelHigh;

  FazpassSettingsBuilder()
      : sensitiveDataList = [],
        isBiometricLevelHigh = false;

  FazpassSettingsBuilder.fromFazpassSettings(FazpassSettings settings)
      : sensitiveDataList = [...settings.sensitiveData],
        isBiometricLevelHigh = settings.isBiometricLevelHigh;

  FazpassSettingsBuilder enableSelectedSensitiveData(List<SensitiveData> sensitiveData) {
    for (final data in sensitiveData) {
      if (sensitiveDataList.contains(data)) {
        continue;
      } else {
        sensitiveDataList.add(data);
      }
    }
    return this;
  }

  FazpassSettingsBuilder disableSelectedSensitiveData(List<SensitiveData> sensitiveData) {
    for (final data in sensitiveData) {
      if (sensitiveDataList.contains(data)) {
        sensitiveDataList.remove(data);
      } else {
        continue;
      }
    }
    return this;
  }

  FazpassSettingsBuilder setBiometricLevelToHigh() {
    isBiometricLevelHigh = true;
    return this;
  }

  FazpassSettingsBuilder setBiometricLevelToLow() {
    isBiometricLevelHigh = false;
    return this;
  }

  FazpassSettings build() => FazpassSettings._(
    sensitiveDataList,
    isBiometricLevelHigh);
}