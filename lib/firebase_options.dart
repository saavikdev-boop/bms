import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB3PYLsD2QHk7hKxSjhyqH6VnCQQIc9VTc',
    appId: '1:312328302719:web:abcdef123456789',
    messagingSenderId: '312328302719',
    projectId: 'bms-saavik',
    authDomain: 'bms-saavik.firebaseapp.com',
    storageBucket: 'bms-saavik.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3PYLsD2QHk7hKxSjhyqH6VnCQQIc9VTc',
    appId: '1:312328302719:android:e49837d9901b12ef49cf4a',
    messagingSenderId: '312328302719',
    projectId: 'bms-saavik',
    authDomain: 'bms-saavik.firebaseapp.com',
    storageBucket: 'bms-saavik.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3PYLsD2QHk7hKxSjhyqH6VnCQQIc9VTc',
    appId: '1:312328302719:ios:abcdef123456789',
    messagingSenderId: '312328302719',
    projectId: 'bms-saavik',
    authDomain: 'bms-saavik.firebaseapp.com',
    storageBucket: 'bms-saavik.firebasestorage.app',
    iosBundleId: 'com.example.flutterPhoneApp',
  );
}