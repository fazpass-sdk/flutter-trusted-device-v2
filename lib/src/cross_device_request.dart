
import 'dart:core';

import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

/// An object containing data from cross device notification request.
///
/// This object is only used as data retrieved from [Fazpass.getCrossDeviceRequestStreamInstance]
/// and [Fazpass.getCrossDeviceRequestFromNotification].
/// It's only constructor, [CrossDeviceRequest.fromData], isn't supposed to
/// be called independently.
class CrossDeviceRequest {
  final String merchantAppId;
  final int expired;
  final String deviceReceive; //vivo/user/MT6769V/CZ/Android 31
  final String deviceRequest; //google/userdebug/11th Gen Intel(R) Core(TM) i5-11400H @ 2.70GHz/Android 31
  final String deviceIdReceive; //390614ec-a507-4a49-b987-5547ce874ce5
  final String deviceIdRequest; //42bb672c-8eef-48c8-b4e3-40617dcb7f41

  CrossDeviceRequest.fromData(Map data) :
        merchantAppId = data["merchant_app_id"] as String,
        expired = int.tryParse(data["expired"] as String) ?? 0,
        deviceReceive = data["device_receive"] as String,
        deviceRequest = data["device_request"] as String,
        deviceIdReceive = data["device_id_receive"] as String,
        deviceIdRequest = data["device_id_request"] as String;
}
