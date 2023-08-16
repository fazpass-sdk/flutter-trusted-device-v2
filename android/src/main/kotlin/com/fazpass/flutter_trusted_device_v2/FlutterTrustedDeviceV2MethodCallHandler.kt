package com.fazpass.flutter_trusted_device_v2

import android.app.Activity
import android.content.Context
import com.fazpass.android_trusted_device_v2.Fazpass
import com.fazpass.android_trusted_device_v2.SensitiveData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class FlutterTrustedDeviceV2MethodCallHandler(private val context: Context) : MethodCallHandler {

    var activity: Activity? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                val assetName = call.arguments as String
                Fazpass.instance.init(context, assetName)
                result.success(null)
            }
            "generateMeta" -> {
                if (activity == null) return
                Fazpass.instance.generateMeta(activity!!) { meta, error ->
                    if (error != null) {
                        result.error("0", error.message, error.cause)
                    }
                    else {
                        result.success(meta)
                    }
                }
            }
            "enableSelected" -> {
                val arguments = call.arguments as List<*>
                val selected = arguments.mapNotNull {
                    try {
                        SensitiveData.valueOf(it as String)
                    } catch (_: IllegalArgumentException) {
                        null
                    }
                }
                Fazpass.instance.enableSelected(*selected.toTypedArray())
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}