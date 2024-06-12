package com.fazpass.flutter_trusted_device_v2

import android.content.Context
import com.fazpass.android_trusted_device_v2.Fazpass
import io.flutter.plugin.common.EventChannel

class FlutterTrustedDeviceV2CDStreamHandler(context: Context) : EventChannel.StreamHandler {

    private val stream = Fazpass.instance.getCrossDeviceDataStreamInstance(context)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        stream.listen {
            events?.success(it.toMap())
        }
    }

    override fun onCancel(arguments: Any?) {
        stream.close()
    }
}