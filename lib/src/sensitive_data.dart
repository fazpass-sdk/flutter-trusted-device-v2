
/// Enum class which contains all kinds of data that requires certain permissions before it
/// could be collected.
enum SensitiveData {
  /// AVAILABILITY: ANDROID, IOS
  ///
  /// To enable location on android, make sure you require these permissions:
  /// - android.permission.ACCESS_COARSE_LOCATION or android.permission.ACCESS_FINE_LOCATION
  /// - android.permission.FOREGROUND_SERVICE
  ///
  /// To enable location on ios, declare NSLocationWhenInUseUsageDescription in your Info.plist file
  location,
  /// AVAILABILITY: IOS
  ///
  /// To enable vpn on ios, follow Apple guidelines on how to get special privilege to use NEVPNManager.
  /// after you have the permission to do so, you can immediately enable it.
  vpn,
  /// AVAILABILITY: ANDROID
  ///
  /// To enable sim numbers and operators on android, make sure you require these permissions:
  /// - android.permission.READ_PHONE_NUMBERS
  /// - android.permission.READ_PHONE_STATE
  simNumbersAndOperators,
}