// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMADp2ZsWRYbKwksJDPStgPMyjVSScnsU',
    appId: '1:1089760369116:web:e757ba8b75c019199f1719',
    messagingSenderId: '1089760369116',
    projectId: 'chaudhary-chicken',
    authDomain: 'chaudhary-chicken.firebaseapp.com',
    storageBucket: 'chaudhary-chicken.appspot.com',
    measurementId: 'G-SNGYF2N7GW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuyJ8RHlNwFm_srZJg4B8UKhpR9wir77g',
    appId: '1:1089760369116:android:a1c743e60945e9959f1719',
    messagingSenderId: '1089760369116',
    projectId: 'chaudhary-chicken',
    storageBucket: 'chaudhary-chicken.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBz-NrDnfdg7GPdQdeMQBgoxHamGQ3IsM',
    appId: '1:1089760369116:ios:a3b9c0b25db69bc49f1719',
    messagingSenderId: '1089760369116',
    projectId: 'chaudhary-chicken',
    storageBucket: 'chaudhary-chicken.appspot.com',
    iosClientId: '1089760369116-jfef0m9t6l1m2s385g53m4f5mi37p46d.apps.googleusercontent.com',
    iosBundleId: 'com.miyal.chaudharyChickenUsersApp',
  );
}
