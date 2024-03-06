package com.fazpass.flutter_trusted_device_v2

import android.app.Activity
import android.content.Context
import com.fazpass.android_trusted_device_v2.Fazpass
import com.fazpass.android_trusted_device_v2.FazpassException
import com.fazpass.android_trusted_device_v2.SensitiveData
import com.fazpass.android_trusted_device_v2.`object`.FazpassSettings
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
                val accountIndex = call.arguments as Int
                Fazpass.instance.generateMeta(activity!!, accountIndex) { meta, error ->
                    when (error) {
                        FazpassException.BiometricNoneEnrolledError -> result.error(
                            "fazpassE-biometricNoneEnrolled",
                            error.exception.message,
                            null
                        )
                        FazpassException.BiometricAuthError -> result.error(
                            "fazpassE-biometricAuthFailed",
                            error.exception.message,
                            null
                        )
                        FazpassException.BiometricUnavailableError -> result.error(
                            "fazpassE-biometricUnavailable",
                            error.exception.message,
                            null
                        )
                        FazpassException.BiometricUnsupportedError -> result.error(
                            "fazpassE-biometricUnsupported",
                            error.exception.message,
                            null
                        )
                        FazpassException.EncryptionException -> result.error(
                            "fazpassE-encryptionError",
                            error.exception.message,
                            null
                        )
                        FazpassException.PublicKeyNotExistException -> result.error(
                            "fazpassE-publicKeyNotExist",
                            error.exception.message,
                            null
                        )
                        FazpassException.UninitializedException -> result.error(
                            "fazpassE-uninitialized",
                            error.exception.message,
                            null
                        )
                        FazpassException.BiometricSecurityUpdateRequiredError -> result.error(
                            "fazpassE-biometricSecurityUpdateRequired",
                            error.exception.message,
                            null
                        )
                        null -> result.success(meta)
                    }
                }
            }
            "generateSecretKeyForHighLevelBiometric" -> {
                if (activity == null) return
                try {
                    Fazpass.instance.generateNewSecretKey(activity!!)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("fazpassE-Error", e.message, null)
                }
            }
            "getSettingsForAccountIndex" -> {
                val accountIndex = call.arguments as Int
                val settings = Fazpass.instance.getSettings(accountIndex)
                result.success(settings?.toString())
            }
            "setSettingsForAccountIndex" -> {
                if (activity == null) return
                val args = call.arguments as Map<*, *>
                val accountIndex = args["accountIndex"] as Int
                val settingsString = args["settings"] as String?
                val settings = if (settingsString != null) FazpassSettings.fromString(settingsString) else null
                Fazpass.instance.setSettings(activity!!, accountIndex, settings)
                result.success(null)
            }
            "getCrossDeviceRequestFromNotification" -> {
                if (activity == null) return
                val request = Fazpass.instance.getCrossDeviceRequestFromNotification(activity!!.intent)
                if (request == null) {
                    result.success(null)
                    return
                }

                result.success(mapOf(
                    "merchant_app_id" to request.merchantAppId,
                    "expired" to request.expired,
                    "device_receive" to request.deviceReceive,
                    "device_request" to request.deviceRequest,
                    "device_id_receive" to request.deviceIdReceive,
                    "device_id_request" to request.deviceIdRequest
                ))
            }
            "helper:getAppSignatures" -> {
                if (activity == null) return
                val appSignatures = Fazpass.helper.getAppSignatures(activity!!)
                result.success(appSignatures)
            }
            else -> result.notImplemented()
        }
    }
}