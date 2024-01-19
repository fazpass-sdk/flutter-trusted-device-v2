
/// An enum class which contains all kinds of data that requires certain steps before it
/// could be collected.
enum SensitiveData {
  /// AVAILABILITY: ANDROID, IOS
  ///
  /// To enable location on android, make sure you ask user for these permissions:
  /// - android.permission.ACCESS_COARSE_LOCATION or android.permission.ACCESS_FINE_LOCATION
  /// - android.permission.FOREGROUND_SERVICE
  ///
  /// To enable location on ios, declare NSLocationWhenInUseUsageDescription in your Info.plist file
  location,
  /// AVAILABILITY: IOS
  ///
  /// To enable vpn on ios, add Network Extensions capability in your project.
  vpn,
  /// AVAILABILITY: ANDROID
  ///
  /// To enable sim numbers and operators on android, make sure you ask user for these permissions:
  /// - android.permission.READ_PHONE_NUMBERS
  /// - android.permission.READ_PHONE_STATE
  simNumbersAndOperators,
}