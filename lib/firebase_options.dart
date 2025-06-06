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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCSlks6ON6YiZxJkcPLVFsbU88GwVZ2fMY',
    appId: '1:864389749573:web:d984a82d2b3b905f5c7c2c',
    messagingSenderId: '864389749573',
    projectId: 'zestaevents-8027e',
    authDomain: 'zestaevents-8027e.firebaseapp.com',
    storageBucket: 'zestaevents-8027e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASYrQsIK1NQRxqzYjbhhKCByT7mHlCMpk',
    appId: '1:864389749573:android:a32674543a7c346f5c7c2c',
    messagingSenderId: '864389749573',
    projectId: 'zestaevents-8027e',
    storageBucket: 'zestaevents-8027e.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCSlks6ON6YiZxJkcPLVFsbU88GwVZ2fMY',
    appId: '1:864389749573:web:2ad6d3d7874740a05c7c2c',
    messagingSenderId: '864389749573',
    projectId: 'zestaevents-8027e',
    authDomain: 'zestaevents-8027e.firebaseapp.com',
    storageBucket: 'zestaevents-8027e.firebasestorage.app',
  );
}
