# flutter_chat_app


## Android setup

* Set up firestore configuration from firestore documentation, follow all the steps accordingly

* Download from firestore and put/ replace the file `google-services.json` in your `android/app/` folder

* Add this line (or as provided by firestore) to `android/build.gradle`
  `classpath 'com.google.gms:google-services:4.3.15'`

* Add dependencies as shown in the firestore settings to your
`android/app/build.gradle` file

```dart
dependencies {
      implementation platform('com.google.firebase:firebase-bom:31.2.0')
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'com.google.firebase:firebase-analytics-ktx'
    implementation 'com.android.support:multidex:2.0.1'
    // if the last line (multidex) not found in the firestor setting copy from here 
    // and add as shown. It's important.
}

```

* Set up permission in `android/app/src/AndroidManifest.xml`
```xml
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```
* If there's an error `failed to connect...` turn off and on device wifi 
* If that also does not work, change your Android Emulator version

* Along with other settings, make sure to add and import `firebase_core` and call `WidgetsFlutterBinding.ensureInitialized();` and `await Firebase.initializeApp();` on the `main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

```

* If you face any minimum sdkVersion and target sdkVersion issue, follow as mentioned there.

* No settings required for `image_picker` for latest android
* For android push notification add this code to `android/app/src/main/AndroidManifest.xml` inside `<activity>...</activity>`
```xml
         <intent-filter>
              <action android:name="android.intent.action.MAIN"/>
              <category android:name="android.intent.category.LAUNCHER"/>
          </intent-filter>
          <intent-filter>
              <action android:name="FLUTTER_NOTIFICATION_CLICK"/>
              <category android:name="android.intent.category.DEFAULT"/>
          </intent-filter>
```

## iOS set up
Find the official document and do your own