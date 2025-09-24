// File modified for web only
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.webOnly,
/// );
/// ```
class DefaultFirebaseOptions {
  // Simplified to only provide web configuration
  static FirebaseOptions get webOnly {
    return web;
  }
  
  // Keeping currentPlatform for backward compatibility
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCyeuG3cUnszLZfbgDBlYGkICAOUbOxcZg',
    appId: '1:103422751641:web:8df499583d514b1164d908',
    messagingSenderId: '103422751641',
    projectId: 'belajar-web-flutter',
    authDomain: 'belajar-web-flutter.firebaseapp.com',
    storageBucket: 'belajar-web-flutter.firebasestorage.app',
  );
}
