package com.fazpass.flutter_trusted_device_v2

import android.app.Activity
import android.content.Context
import com.fazpass.android_trusted_device_v2.BiometricAuthError
import com.fazpass.android_trusted_device_v2.BiometricNoneEnrolledError
import com.fazpass.android_trusted_device_v2.BiometricSecurityUpdateRequiredError
import com.fazpass.android_trusted_device_v2.BiometricUnavailableError
import com.fazpass.android_trusted_device_v2.BiometricUnsupportedError
import com.fazpass.android_trusted_device_v2.EncryptionException
import com.fazpass.android_trusted_device_v2.Fazpass
import com.fazpass.android_trusted_device_v2.PublicKeyNotExistException
import com.fazpass.android_trusted_device_v2.SensitiveData
import com.fazpass.android_trusted_device_v2.UninitializedException
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
                    when (error) {
                        is BiometricNoneEnrolledError -> result.error(
                            "fazpassE-biometricNoneEnrolled",
                            error.message,
                            null
                        )
                        is BiometricAuthError -> result.error(
                            "fazpassE-biometricAuthFailed",
                            error.message,
                            null
                        )
                        is BiometricUnavailableError -> result.error(
                            "fazpassE-biometricUnavailable",
                            error.message,
                            null
                        )
                        is BiometricUnsupportedError -> result.error(
                            "fazpassE-biometricUnsupported",
                            error.message,
                            null
                        )
                        is EncryptionException -> result.error(
                            "fazpassE-encryptionError",
                            error.message,
                            null
                        )
                        is PublicKeyNotExistException -> result.error(
                            "fazpassE-publicKeyNotExist",
                            error.message,
                            null
                        )
                        is UninitializedException -> result.error(
                            "fazpassE-uninitialized",
                            error.message,
                            null
                        )
                        is BiometricSecurityUpdateRequiredError -> result.error(
                            "fazpassE-biometricSecurityUpdateRequired",
                            error.message,
                            null
                        )
                        null -> result.success(meta)
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
            "getCrossDeviceRequestFromFirstActivityIntent" -> {
                if (activity == null) {
                    result.error("fazpassE-noActivity", "No activity attached.", null)
                    return
                }
                val request = Fazpass.instance.getCrossDeviceRequestFromFirstActivityIntent(activity!!.intent)
                if (request == null) {
                    result.success(null)
                    return
                }

                result.success(mapOf(
                    "merchant_app_id" to request.merchantAppId,
                    "expired" to request.expired.toString(),
                    "device_receive" to request.deviceReceive,
                    "device_request" to request.deviceRequest,
                    "device_id_receive" to request.deviceIdReceive,
                    "device_id_request" to request.deviceIdRequest
                ))
            }
            else -> result.notImplemented()
        }
    }
}