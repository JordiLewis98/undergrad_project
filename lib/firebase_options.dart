// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyC32z0hB2_6G4Ma8cb8hIDp3iJ2I5Gu0OQ',
    appId: '1:914796198912:web:7e862f6e75d82dc48bace5',
    messagingSenderId: '914796198912',
    projectId: 'autism-helper-c2184',
    authDomain: 'autism-helper-c2184.firebaseapp.com',
    storageBucket: 'autism-helper-c2184.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAC2DcXGzPb3r-LtSRf6olfbsEN5NLCyS8',
    appId: '1:914796198912:android:dbe41bd155be77af8bace5',
    messagingSenderId: '914796198912',
    projectId: 'autism-helper-c2184',
    storageBucket: 'autism-helper-c2184.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpKQFp66klmJyYrj5diH5U7rdzZAHpwmA',
    appId: '1:914796198912:ios:6284b4fc3a3077e48bace5',
    messagingSenderId: '914796198912',
    projectId: 'autism-helper-c2184',
    storageBucket: 'autism-helper-c2184.firebasestorage.app',
    iosBundleId: 'com.example.autismHelper',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBpKQFp66klmJyYrj5diH5U7rdzZAHpwmA',
    appId: '1:914796198912:ios:6284b4fc3a3077e48bace5',
    messagingSenderId: '914796198912',
    projectId: 'autism-helper-c2184',
    storageBucket: 'autism-helper-c2184.firebasestorage.app',
    iosBundleId: 'com.example.autismHelper',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC32z0hB2_6G4Ma8cb8hIDp3iJ2I5Gu0OQ',
    appId: '1:914796198912:web:3d730a6eff93a3308bace5',
    messagingSenderId: '914796198912',
    projectId: 'autism-helper-c2184',
    authDomain: 'autism-helper-c2184.firebaseapp.com',
    storageBucket: 'autism-helper-c2184.firebasestorage.app',
  );
}
