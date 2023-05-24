# flutter-local-file-download
Save image and video files in download folder using flutter.

Working in Android SDK 29 & 30.


Dart 3.0 is compatible.

## 1. Android 
If you are targeting Android 11 (targetSdkVersion 30) then you require the following permissions in AndroidManifest.xml for modifying and document access.
Located in ``` <project root>/android/app/src/main/AndroidManifest.xml ```
   
```
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```
   
 For Android 10 add the following code line in **AndroidManifest.xml** application tag
 ```
 android:requestLegacyExternalStorage="true"
```
## 2. iOS
Add in Info.plist file. Located in ``` <project root>/ios/Runner/Info.plist ```

``` 
<key>UISupportsDocumentBrowser</key>
<true/>
```


## 2. Add a package for asking permission in pubspec.yaml
```
dio: ^5.1.2
permission_handler: ^10.2.0
path_provider: ^2.0.15
```


