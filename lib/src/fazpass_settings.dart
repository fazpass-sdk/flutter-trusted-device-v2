
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

/// An object to be used as settings for [Fazpass.setSettings] method.
///
/// This object isn't meant to be created by itself as it's only constructor,
/// [FazpassSettings.fromString], isn't meant to be called independently.
/// Use [FazpassSettingsBuilder] instead.
class FazpassSettings {
  final List<SensitiveData> _sensitiveData;
  final bool _isBiometricLevelHigh;

  List<SensitiveData> get sensitiveData => _sensitiveData.toList();
  bool get isBiometricLevelHigh => _isBiometricLevelHigh;

  FazpassSettings._(this._sensitiveData, this._isBiometricLevelHigh);

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
  String toString() => "${_sensitiveData.map((it) => it.name).join(",")};$_isBiometricLevelHigh";
}

/// A builder to create [FazpassSettings] object.
///
/// To enable specific sensitive data collection, call [enableSelectedSensitiveData] method
/// and specify which data you want to collect.
/// Otherwise call [disableSelectedSensitiveData] method
/// and specify which data you don't want to collect.
/// To set biometric level to high, call [setBiometricLevelToHigh]. Otherwise call
/// [setBiometricLevelToLow].
/// To create [FazpassSettings] object with this builder configuration, call [build] method.
/// ```dart
/// FazpassSettings settings = FazpassSettingsBuilder()
///   .enableSelectedSensitiveData([SensitiveData.location])
///   .setBiometricLevelToHigh()
///   .build();
/// ```
///
/// You can also copy settings from [FazpassSettings] by using [FazpassSettingsBuilder.fromFazpassSettings]
/// constructor.
/// ```dart
/// FazpassSettingsBuilder builder =
///   FazpassSettingsBuilder.fromFazpassSettings(settings);
/// ```
class FazpassSettingsBuilder {
  final List<SensitiveData> _sensitiveData;
  bool _isBiometricLevelHigh;

  List<SensitiveData> get sensitiveData => _sensitiveData.toList();
  bool get isBiometricLevelHigh => _isBiometricLevelHigh;

  FazpassSettingsBuilder()
      : _sensitiveData = [],
        _isBiometricLevelHigh = false;

  FazpassSettingsBuilder.fromFazpassSettings(FazpassSettings settings)
      : _sensitiveData = [...settings._sensitiveData],
        _isBiometricLevelHigh = settings._isBiometricLevelHigh;

  FazpassSettingsBuilder enableSelectedSensitiveData(List<SensitiveData> sensitiveData) {
    for (final data in sensitiveData) {
      if (_sensitiveData.contains(data)) {
        continue;
      } else {
        _sensitiveData.add(data);
      }
    }
    return this;
  }

  FazpassSettingsBuilder disableSelectedSensitiveData(List<SensitiveData> sensitiveData) {
    for (final data in sensitiveData) {
      if (_sensitiveData.contains(data)) {
        _sensitiveData.remove(data);
      } else {
        continue;
      }
    }
    return this;
  }

  FazpassSettingsBuilder setBiometricLevelToHigh() {
    _isBiometricLevelHigh = true;
    return this;
  }

  FazpassSettingsBuilder setBiometricLevelToLow() {
    _isBiometricLevelHigh = false;
    return this;
  }

  FazpassSettings build() => FazpassSettings._(
    _sensitiveData,
    _isBiometricLevelHigh);
}