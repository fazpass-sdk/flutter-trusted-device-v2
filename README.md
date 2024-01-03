# flutter_trusted_device_v2

This is the Official flutter package for Fazpass Trusted Device V2.
If you want to use native sdk for android, you can find it here: https://github.com/fazpass-sdk/android-trusted-device-v2 <br>
For ios counterpart, you can find it here: https://github.com/fazpass-sdk/ios-trusted-device-v2 <br>
Visit [official website](https://fazpass.com) for more information about the product and see documentation at [online documentation](https://doc.fazpass.com) for more technical details.

## Minimum OS

Android 24, IOS 13.0

## Getting Started

Before using our product, make sure to contact us first to get keypair of public key and private key. 
after you have each of them:
- On Android: put the public key into the assets folder.
- On iOS: reference the public key in your Xcode project Assets.

This package main purpose is to generate meta which you can use to communicate with Fazpass rest API. But
before calling generate meta method, you have to initialize it first by calling this method:
```dart
Fazpass.instance.init("YOUR_PUBLIC_KEY_ASSET_NAME");
```

### Getting Started on Android

1. Open android folder, then go to app/src/main/assets/ (if assets folder doesn't exist, create a new one)
2. Put the public key in this folder

### Getting Started on iOS

1. In your Xcode project, open Assets.
2. Add new asset as Data Set.
3. Reference your public key into this asset.
4. Name your asset.

Then, you have to declare NSFaceIDUsageDescription in your Info.plist file to be able to generate meta, because generating meta requires user to do biometry authentication.

## Usage

Call `Future<String> generateMeta()` method to generate meta. This method collects specific information and generates meta data as Base64 string. You can use this meta to hit Fazpass API endpoint. Will launch biometric authentication before generating meta. Meta will be empty string if exception is present.

```dart
String meta = '';
try {
  meta = await _fazpass.generateMeta();
} on FazpassException catch (e) {
  switch (e) {
    case BiometricNoneEnrolledError():
      // TODO
      break;
    case BiometricAuthFailedError():
      // TODO
      break;
    case BiometricUnavailableError():
      // TODO
      break;
    case BiometricUnsupportedError():
      // TODO
      break;
    case EncryptionException():
      // TODO
      break;
    case PublicKeyNotExistException():
      // TODO
      break;
    case UninitializedException():
      // TODO
      break;
    case BiometricSecurityUpdateRequiredError():
      // TODO
      break;
    case UnknownError():
      // TODO
      break;
  }
}
```

## Exceptions & Errors

#### UninitializedException

Produced when fazpass init method hasn't been called once.

#### PublicKeyNotExistException

- Android: Produced when public key with the name registered in init method doesn't exist in the assets directory.
- iOS: Produced when public key with the name registered in init method doesn't exist as an asset.

#### EncryptionException

Produced when encryption went wrong because you used the wrong public key.

#### BiometricAuthError

Produced when biometric authentication is finished with an error. (example: User cancelled biometric auth, User failed biometric auth too many times, and many more).

#### BiometricUnavailableError

- Android: Produced when device can't start biometric authentication because there is no suitable hardware (e.g. no biometric sensor or no keyguard) or the hardware is unavailable.
- iOS: Produced when device can't start biometry authentication because biometry is unavailable.

#### BiometricNoneEnrolledError

- Android: Produced when device can't start biometric authentication because there is no biometric (e.g. Fingerprint, Face, Iris) or device credential (e.g. PIN, Password, Pattern) enrolled.
- iOS: Produced when device can't start biometry authentication because there is no biometry (Touch ID or Face ID) or device passcode enrolled.

#### BiometricUnsupportedError

- Android: Produced when device can't start biometric authentication because the specified options are incompatible with the current Android version.
- iOS: Produced when device can't start biometry authentication because displaying the required authentication user interface is forbidden. To fix this, you have to permit the display of the authentication UI by setting the interactionNotAllowed property to false.

### Android Exclusive Exceptions

#### BiometricSecurityUpdateRequiredError

Produced when device can't start biometric authentication because a security vulnerability has been discovered with one or
more hardware sensors. The affected sensor(s) are unavailable until a security update has addressed the issue.

### iOS Exclusive Errors

#### UnknownError

Produced when an unknown error has been occured when trying to generate meta.

## Data Collection

Data collected and stored in generated meta. Based on data sensitivity, data type is divided into two: General data and Sensitive data.
General data is always collected while Sensitive data requires more complicated procedures to enable it.

To enable Sensitive data collection, after calling fazpass init method, you need to call `enableSelected(vararg sensitiveData: SensitiveData)` method and
specifies which sensitive data you want to collect.
```dart
Fazpass.instance.enableSelected([
    SensitiveData.location,
    SensitiveData.simNumbersAndOperators,
    SensitiveData.vpn
]);
```
Lastly, you have to follow the procedure to enable each of them as described in their own segment down below.

### General data collected

* Your device platform name (Value will be "android" on android, and "ios" on iOS).
* Your app package name (bundle identifier on iOS).
* Your app debug status.
* Your device rooted status (jailbroken status on iOS).
* Your device emulator/simulator status.
* Your app cloned status. (Android only)
* Your device mirroring or projecting status.
* Your app signatures. (Android only)
* Your device information (Android/iOS version, phone brand/model, phone type, phone cpu).
* Your network IP Address.
* Your network vpn status. (Android only)

### Sensitive data collected

#### Your device location and mock location status

AVAILABILITY: ANDROID, IOS

To enable location on android, make sure you ask user for these permissions:
- android.permission.ACCESS_COARSE_LOCATION or android.permission.ACCESS_FINE_LOCATION
- android.permission.FOREGROUND_SERVICE

To enable location on ios, declare NSLocationWhenInUseUsageDescription in your Info.plist file

#### Your device SIM numbers and operators (if available)

AVAILABILITY: ANDROID

To enable sim numbers and operators on android, make sure you ask user for these permissions:
* android.permission.READ_PHONE_NUMBERS
* android.permission.READ_PHONE_STATE

#### Your network vpn status

AVAILABILITY: IOS

To enable vpn on iOS, you have to add Network Extensions Entitlement to your project.
To add this entitlement to an iOS app or a Mac App Store app, enable the Network Extensions capability in Xcode.
To add this entitlement to a macOS app distributed outside of the Mac App Store, perform the following steps:
1. In the Certificates, Identifiers and Profiles section of the developer site, enable the Network Extension capability for your Developer ID–signed app. Generate a new provisioning profile and download it.
2. On your Mac, drag the downloaded provisioning profile to Xcode to install it.
3. In your Xcode project, enable manual signing and select the provisioning profile downloaded earlier and its associated certificate.
4. Update the project’s entitlements.plist to include the com.apple.developer.networking.networkextension key and the values of the entitlement.

[Apple documentation of network extensions entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_networkextension)
