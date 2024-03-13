// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...



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
    apiKey: 'AIzaSyA3KWYai7N4oWEbAOa9GGsbGMEVJqgodfQ',
    appId: '1:219091452172:web:3a36b7a06c77a195530929',
    messagingSenderId: '219091452172',
    projectId: 'fertilizer-recommendatio-f9b82',
    authDomain: 'fertilizer-recommendatio-f9b82.firebaseapp.com',
    databaseURL: 'https://fertilizer-recommendatio-f9b82-default-rtdb.firebaseio.com',
    storageBucket: 'fertilizer-recommendatio-f9b82.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNKy2v5HQS2Ge5ZxytXVs-L9ZCZDqQh7M',
    appId: '1:219091452172:android:626506759939dd03530929',
    messagingSenderId: '219091452172',
    projectId: 'fertilizer-recommendatio-f9b82',
    databaseURL: 'https://fertilizer-recommendatio-f9b82-default-rtdb.firebaseio.com',
    storageBucket: 'fertilizer-recommendatio-f9b82.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABE0QmSDzmDgRcLuCo1lksjlbKsV6a3sc',
    appId: '1:219091452172:ios:25e7c54944dd916c530929',
    messagingSenderId: '219091452172',
    projectId: 'fertilizer-recommendatio-f9b82',
    databaseURL: 'https://fertilizer-recommendatio-f9b82-default-rtdb.firebaseio.com',
    storageBucket: 'fertilizer-recommendatio-f9b82.appspot.com',
    iosBundleId: 'com.example.frsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABE0QmSDzmDgRcLuCo1lksjlbKsV6a3sc',
    appId: '1:219091452172:ios:56cac326c94af803530929',
    messagingSenderId: '219091452172',
    projectId: 'fertilizer-recommendatio-f9b82',
    databaseURL: 'https://fertilizer-recommendatio-f9b82-default-rtdb.firebaseio.com',
    storageBucket: 'fertilizer-recommendatio-f9b82.appspot.com',
    iosBundleId: 'com.example.frsApp.RunnerTests',
  );
}




