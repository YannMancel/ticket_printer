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

### Update bluetooth_print package
The [bluetooth_print][dependency_bluetooth_print] package is in version 4.3.0.
To print a label with the desired dimensions, you need to modify the native source code for Android and Apple.

In the **bluetooth_print-4.3.0/android/src/main/java/com/example/bluetooth_print/PrintContent.java** let’s update:
```java 
// {type:'text|barcode|qrcode|image', content:'', x:0,y:0}
for (Map<String,Object> m: list) {

      String type = (String)m.get("type");
      String content = (String)m.get("content");
      int x = (int)(m.get("x")==null?0:m.get("x")); //dpi: 1mm约为8个点
      int y = (int)(m.get("y")==null?0:m.get("y"));
      int imageWidth = (int)(m.get("width")==null?0:m.get("width"));

      if("text".equals(type)){
            // 绘制简体中文
            tsc.addText(x, y, LabelCommand.FONTTYPE.SIMPLIFIED_CHINESE, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1, content);
            //打印繁体
            //tsc.addUnicodeText(10,32, LabelCommand.FONTTYPE.TRADITIONAL_CHINESE, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1,"BIG5碼繁體中文字元","BIG5");
            //打印韩文
            //tsc.addUnicodeText(10,60, LabelCommand.FONTTYPE.KOREAN, LabelCommand.ROTATION.ROTATION_0, LabelCommand.FONTMUL.MUL_1, LabelCommand.FONTMUL.MUL_1,"Korean 지아보 하성","EUC_KR");
      }else if("barcode".equals(type)){
            tsc.add1DBarcode(x, y, LabelCommand.BARCODETYPE.CODE128, 100, LabelCommand.READABEL.EANBEL, LabelCommand.ROTATION.ROTATION_0, content);
      }else if("qrcode".equals(type)){
            tsc.addQRCode(x,y, LabelCommand.EEC.LEVEL_L, 5, LabelCommand.ROTATION.ROTATION_0, content);
      }else if("image".equals(type)){
            byte[] bytes = Base64.decode(content, Base64.DEFAULT);
            Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
            tsc.addBitmap(x, y, LabelCommand.BITMAP_MODE.OVERWRITE, imageWidth, bitmap);
      }
}
```

In the **bluetooth_print-4.3.0/ios/Classes/BluetoothPrintPlugin.m** let’s update:
```swift 
for(NSDictionary *m in list){
    
    NSString *type = [m objectForKey:@"type"];
    NSString *content = [m objectForKey:@"content"];
    NSNumber *x = ![m objectForKey:@"x"]?@0 : [m objectForKey:@"x"];
    NSNumber *y = ![m objectForKey:@"y"]?@0 : [m objectForKey:@"y"];
    NSNumber *imageWidth = ![m objectForKey:@"width"]?@0 : [m objectForKey:@"width"];
    
    if([@"text" isEqualToString:type]){
        [command addTextwithX:[x intValue] withY:[y intValue] withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:content];
    }else if([@"barcode" isEqualToString:type]){
        [command add1DBarcode:[x intValue] :[y intValue] :@"CODE128" :100 :1 :0 :2 :2 :content];
    }else if([@"qrcode" isEqualToString:type]){
        [command addQRCode:[x intValue] :[y intValue] :@"L" :5 :@"A" :0 :content];
    }else if([@"image" isEqualToString:type]){
        NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:content options:0];
        UIImage *image = [UIImage imageWithData:decodeData];
        [command addBitmapwithX:[x intValue] withY:[y intValue] withMode:0 withWidth:imageWidth withImage:image];
    }
    
}
```

## Dependencies
* Flutter Version Management
  * [fvm][dependency_fvm]
* Linter
  * [flutter_lints][dependency_flutter_lints]
* Data class generator
  * [build_runner][dependency_build_runner]
  * [freezed][dependency_freezed]
  * [freezed_annotation][dependency_freezed_annotation]
* State manager
  * [flutter_bloc][dependency_flutter_bloc]
* Bluetooth & Print
  * [bluetooth_print][dependency_bluetooth_print]
* Tests
  * [mockito][dependency_mockito]
  * [bloc_test][dependency_bloc_test]

[badge_flutter]: https://img.shields.io/badge/flutter-v3.10.5-blue?logo=flutter
[link_flutter_release]: https://docs.flutter.dev/development/tools/sdk/releases
[link_apple_requesting_authorization_for_location_services]: https://developer.apple.com/documentation/corelocation/requesting_authorization_for_location_services
[dependency_fvm]: https://fvm.app/
[dependency_flutter_lints]: https://pub.dev/packages/flutter_lints
[dependency_build_runner]: https://pub.dev/packages/build_runner
[dependency_freezed]: https://pub.dev/packages/freezed
[dependency_freezed_annotation]: https://pub.dev/packages/freezed_annotation
[dependency_flutter_bloc]: https://pub.dev/packages/flutter_bloc
[dependency_bluetooth_print]: https://pub.dev/packages/bluetooth_print
[dependency_mockito]: https://pub.dev/packages/mockito
[dependency_bloc_test]: https://pub.dev/packages/bloc_test
