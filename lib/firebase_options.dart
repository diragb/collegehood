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
        return macos;
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
    apiKey: 'AIzaSyDCZbQ7qyJ4WArwN_YmBLDvzCu9HJBpNr4',
    appId: '1:124447812672:web:4885213815b0fc9e4803a5',
    messagingSenderId: '124447812672',
    projectId: 'collegehood-io',
    authDomain: 'collegehood-io.firebaseapp.com',
    storageBucket: 'collegehood-io.appspot.com',
    measurementId: 'G-TT89LNHX7H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASEP_awNWNMROstlcE-cxpf7l7gPJVE9E',
    appId: '1:124447812672:android:1a2d8fde0a53b87b4803a5',
    messagingSenderId: '124447812672',
    projectId: 'collegehood-io',
    storageBucket: 'collegehood-io.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDQCmK53qwH-pHbEWSi32QWQENUWQVA5sk',
    appId: '1:124447812672:ios:e00459db36864dc74803a5',
    messagingSenderId: '124447812672',
    projectId: 'collegehood-io',
    storageBucket: 'collegehood-io.appspot.com',
    iosClientId: '124447812672-fso7535pg4mo8dmbhm385om06550vs2a.apps.googleusercontent.com',
    iosBundleId: 'com.example.collegehood',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDQCmK53qwH-pHbEWSi32QWQENUWQVA5sk',
    appId: '1:124447812672:ios:e00459db36864dc74803a5',
    messagingSenderId: '124447812672',
    projectId: 'collegehood-io',
    storageBucket: 'collegehood-io.appspot.com',
    iosClientId: '124447812672-fso7535pg4mo8dmbhm385om06550vs2a.apps.googleusercontent.com',
    iosBundleId: 'com.example.collegehood',
  );
}
