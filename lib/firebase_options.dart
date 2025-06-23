import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAndlvs5NpG24H6tA4vPTiBnYWpYyBmu24',
    appId: '1:352900433184:web:98a36f61e0c5c5cf5d8345',
    messagingSenderId: '352900433184',
    projectId: 'gymappproject-2f7b9',
    authDomain: 'gymappproject-2f7b9.firebaseapp.com',
    storageBucket: 'gymappproject-2f7b9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBccVxnb-atztHFA_4FTyRSS85AyXvhxSY',
    appId: '1:352900433184:android:4b848ee96a326ffc5d8345',
    messagingSenderId: '352900433184',
    projectId: 'gymappproject-2f7b9',
    storageBucket: 'gymappproject-2f7b9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1I0cjkUqkPYU6uYgAceUyAjl_USlRm9Y',
    appId: '1:352900433184:ios:906dc211e2fac0f15d8345',
    messagingSenderId: '352900433184',
    projectId: 'gymappproject-2f7b9',
    storageBucket: 'gymappproject-2f7b9.firebasestorage.app',
    iosClientId: '352900433184-93pajrv4ie9i2g76j09vfd0ll2j72pak.apps.googleusercontent.com',
    iosBundleId: 'com.example.gymApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1I0cjkUqkPYU6uYgAceUyAjl_USlRm9Y',
    appId: '1:352900433184:ios:906dc211e2fac0f15d8345',
    messagingSenderId: '352900433184',
    projectId: 'gymappproject-2f7b9',
    storageBucket: 'gymappproject-2f7b9.firebasestorage.app',
    iosClientId: '352900433184-93pajrv4ie9i2g76j09vfd0ll2j72pak.apps.googleusercontent.com',
    iosBundleId: 'com.example.gymApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAndlvs5NpG24H6tA4vPTiBnYWpYyBmu24',
    appId: '1:352900433184:web:13eabd202326a7f55d8345',
    messagingSenderId: '352900433184',
    projectId: 'gymappproject-2f7b9',
    authDomain: 'gymappproject-2f7b9.firebaseapp.com',
    storageBucket: 'gymappproject-2f7b9.firebasestorage.app',
  );
}