
import 'dart:core';

import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

/// An object containing data from cross device notification request.
///
/// This object is only used as data retrieved from [Fazpass.getCrossDeviceDataStreamInstance]
/// and [Fazpass.getCrossDeviceDataFromNotification].
/// It's only constructor, [CrossDeviceRequest.fromData], isn't supposed to
/// be called independently.
class CrossDeviceData {
  final String merchantAppId;
  /// example: Google;V3;MT6769V/CZ;Android 31
  final String deviceReceive;
  /// example: Google;V3;MT6769V/CZ;Android 31
  final String deviceRequest;
  final String deviceIdReceive; //390614ec-a507-4a49-b987-5547ce874ce5
  final String deviceIdRequest; //42bb672c-8eef-48c8-b4e3-40617dcb7f41
  final String expired;
  /// either 'request' or 'validate'
  final String status;
  /// if status is 'request' only
  final String? notificationId;
  /// if status is 'validate' only
  final String? action;

  CrossDeviceData.fromData(Map data) :
        merchantAppId = data["merchant_app_id"] as String,
        deviceReceive = data["device_receive"] as String,
        deviceRequest = data["device_request"] as String,
        deviceIdReceive = data["device_id_receive"] as String,
        deviceIdRequest = data["device_id_request"] as String,
        expired = data["expired"] as String,
        status = data["status"] as String,
        notificationId = data["notification_id"] as String?,
        action = data["action"] as String?;
}
