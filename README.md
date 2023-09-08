# flutter_trusted_device_v2

This is the Official flutter package for Fazpass Trusted Device V2.
If you want to use native sdk for android, you can find it here: https://github.com/fazpass-sdk/android-trusted-device-v2 <br>
For ios counterpart, you can find it here: https://github.com/fazpass-sdk/ios-trusted-device-v2 <br>
Visit [official website](https://fazpass.com) for more information about the product and see documentation at [online documentation](https://doc.fazpass.com) for more technical details.

## Minimum OS

Android 23, IOS 13.0

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

```dart
String? meta;
try {
  meta = await Fazpass.instance.generateMeta();
} catch (e) {
  // handle error here
}
```