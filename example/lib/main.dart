import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _meta = 'Not generated yet';
  final _fazpass = Fazpass.instance;

  @override
  void initState() {
    super.initState();

    _fazpass.getAppSignatures().then((value) => print("APPSGN: $value"));

    initializeFazpass()
      .then((value) => setFazpassSettings())
      .then((value) => generateMeta());
  }

  Future<void> initializeFazpass() async {
    // initialize fazpass package
    await _fazpass.init(androidAssetName: 'my_public_key.pub');
  }

  Future<void> setFazpassSettings() async {
    // create settings
    final settings = FazpassSettingsBuilder()
        .enableSelectedSensitiveData([SensitiveData.simNumbersAndOperators, SensitiveData.location])
        .setBiometricLevelToHigh()
        .build();
    // generate new secret key so we can use high-level biometric
    await _fazpass.generateNewSecretKey();
    // save settings
    await _fazpass.setSettings(1, settings);
  }

  Future<void> generateMeta() async {
    String meta = 'Failed to generate meta.';
    try {
      // generate meta and apply saved settings for account index 1
      meta = await _fazpass.generateMeta(accountIndex: 1);
    } on FazpassException catch (e) {
      switch (e) {
        case BiometricNoneEnrolledError():
          // TODO
          break;
        case BiometricAuthFailedError():
          // TODO
          break;
        case BiometricUnavailableError():
          // TODO
          break;
        case BiometricUnsupportedError():
          // TODO
          break;
        case EncryptionException():
          // TODO
          break;
        case PublicKeyNotExistException():
          // TODO
          break;
        case UninitializedException():
          // TODO
          break;
        case BiometricSecurityUpdateRequiredError():
          // TODO
          break;
      }
    }

    if (!mounted) return;

    setState(() {
      _meta = meta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(_meta),
        ),
      ),
    );
  }
}
