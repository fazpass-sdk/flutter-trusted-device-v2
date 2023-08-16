package com.fazpass.flutter_trusted_device_v2

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

/** FlutterTrustedDeviceV2Plugin */
class FlutterTrustedDeviceV2Plugin: FlutterPlugin, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var handler: FlutterTrustedDeviceV2MethodCallHandler

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_trusted_device_v2")
    handler = FlutterTrustedDeviceV2MethodCallHandler(flutterPluginBinding.applicationContext)
    channel.setMethodCallHandler(handler)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    handler.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    handler.activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    handler.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    handler.activity = null
  }
}
