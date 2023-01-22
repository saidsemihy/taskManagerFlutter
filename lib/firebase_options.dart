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
    apiKey: 'AIzaSyB8LhomyLE6Duz4hl1kizAnM6TcMBXGa78',
    appId: '1:1098074934066:web:d5162e21060b747d0d652b',
    messagingSenderId: '1098074934066',
    projectId: 'istakip-90248',
    authDomain: 'istakip-90248.firebaseapp.com',
    storageBucket: 'istakip-90248.appspot.com',
    measurementId: 'G-DSM66TP4X5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpIEoTQJXAV01NxC4MetI05ZtBqbyWJ-g',
    appId: '1:1098074934066:android:fba3537f78db39510d652b',
    messagingSenderId: '1098074934066',
    projectId: 'istakip-90248',
    storageBucket: 'istakip-90248.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBogUiuIihlrE3nvBOXi9V-kAILEyESQqM',
    appId: '1:1098074934066:ios:07af5c2b8c71644a0d652b',
    messagingSenderId: '1098074934066',
    projectId: 'istakip-90248',
    storageBucket: 'istakip-90248.appspot.com',
    iosClientId: '1098074934066-dbk23odrimqjjo92k9jf1o5moj5qm5oe.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskmanagmentapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBogUiuIihlrE3nvBOXi9V-kAILEyESQqM',
    appId: '1:1098074934066:ios:07af5c2b8c71644a0d652b',
    messagingSenderId: '1098074934066',
    projectId: 'istakip-90248',
    storageBucket: 'istakip-90248.appspot.com',
    iosClientId: '1098074934066-dbk23odrimqjjo92k9jf1o5moj5qm5oe.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskmanagmentapp',
  );
}