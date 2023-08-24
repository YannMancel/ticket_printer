[![badge_flutter]][link_flutter_release]

# ticket_printer
**Goal**: A Flutter project to manage ticket printer.

## Setup the project in Android studio
1. Download the project code, preferably using `git clone git@github.com:YannMancel/ticket_printer.git`.
2. In Android Studio, select *File* | *Open...*
3. Select the project

## Getting Started

### Change the minSdkVersion for Android
bluetooth_print is compatible only from version 21 of Android SDK so you should change this in **android/app/build.gradle**:
```gradle
  Android {
    defaultConfig {
       minSdkVersion: 21
```

### Add permissions for Bluetooth
We need to add the permission to use Bluetooth and access location:

#### **Android**
In the **android/app/src/main/AndroidManifest.xml** let’s add:
```xml 
	 <uses-permission android:name="android.permission.BLUETOOTH" />  
	 <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
     <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
	 <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />  
	 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>  
 <application
```
#### **IOS**
In the **ios/Runner/Info.plist** let’s add:
```dart 
	<dict>  
	    <key>NSBluetoothAlwaysUsageDescription</key>  
	    <string>Need BLE permission</string>  
	    <key>NSBluetoothPeripheralUsageDescription</key>  
	    <string>Need BLE permission</string>  
	    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>  
	    <string>Need Location permission</string>  
	    <key>NSLocationAlwaysUsageDescription</key>  
	    <string>Need Location permission</string>  
	    <key>NSLocationWhenInUseUsageDescription</key>  
	    <string>Need Location permission</string>
```

For location permissions on iOS see more at: [https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services][link_apple_requesting_authorization_for_location_services]

## Dependencies
* Flutter Version Management
  * [fvm][dependency_fvm]
* Linter
  * [flutter_lints][dependency_flutter_lints]
* State manager
  * [flutter_bloc][dependency_flutter_bloc]
* Bluetooth & Print
  * [Fork of bluetooth_print][link_fork_bluetooth_print] (Fork of [bluetooth_print][dependency_bluetooth_print])
* Equalities
  * [collection][dependency_collection]
* Tests
  * [mockito][dependency_mockito]
  * [bloc_test][dependency_bloc_test]
* Data class generator
  * [build_runner][dependency_build_runner]

[badge_flutter]: https://img.shields.io/badge/flutter-v3.10.5-blue?logo=flutter
[link_flutter_release]: https://docs.flutter.dev/development/tools/sdk/releases
[link_apple_requesting_authorization_for_location_services]: https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services
[link_fork_bluetooth_print]: https://github.com/YannMancel/bluetooth_print/tree/fix-image-size-for-tsc-command
[dependency_fvm]: https://fvm.app/
[dependency_flutter_lints]: https://pub.dev/packages/flutter_lints
[dependency_flutter_bloc]: https://pub.dev/packages/flutter_bloc
[dependency_bluetooth_print]: https://pub.dev/packages/bluetooth_print
[dependency_collection]: https://pub.dev/packages/collection
[dependency_mockito]: https://pub.dev/packages/mockito
[dependency_bloc_test]: https://pub.dev/packages/bloc_test
[dependency_build_runner]: https://pub.dev/packages/build_runner
