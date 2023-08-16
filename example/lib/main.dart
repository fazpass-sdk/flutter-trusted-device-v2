import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
    initGenerateMetaState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initGenerateMetaState() async {
    await _fazpass.init("my_public_key.pub");
    await _fazpass.enableSelected([SensitiveData.simNumbersAndOperators]);

    String meta;
    try {
      meta = await _fazpass.generateMeta() ?? 'Generate meta failed';
    } catch (e) {
      meta = 'Failed to generate meta.';
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
