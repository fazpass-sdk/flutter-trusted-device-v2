package com.fazpass.flutter_trusted_device_v2

import android.content.Context
import com.fazpass.android_trusted_device_v2.Fazpass
import io.flutter.plugin.common.EventChannel

class FlutterTrustedDeviceV2CDStreamHandler(context: Context) : EventChannel.StreamHandler {

    private val stream = Fazpass.instance.getCrossDeviceRequestStreamInstance(context)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        stream.listen {
            events?.success(mapOf(
                "merchant_app_id" to it.merchantAppId,
                "expired" to it.expired,
                "device_receive" to it.deviceReceive,
                "device_request" to it.deviceRequest,
                "device_id_receive" to it.deviceIdReceive,
                "device_id_request" to it.deviceIdRequest
            ))
        }
    }

    override fun onCancel(arguments: Any?) {
        stream.close()
    }
}