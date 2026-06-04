// Fichier généré par FlutterFire CLI.
// Exécutez dans le dossier du projet :
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Puis remplacez ce fichier par la version générée.

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
      default:
        throw UnsupportedError(
          'Plateforme non configurée. Lancez: flutterfire configure',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPy74NmJE_cil1mk098hCXf9tw859DDX8',
    appId: '1:511053793923:web:a8ec3c48a6c4682e6de9b6',
    messagingSenderId: '511053793923',
    projectId: 'stock-flutter-c3552',
    authDomain: 'stock-flutter-c3552.firebaseapp.com',
    storageBucket: 'stock-flutter-c3552.firebasestorage.app',
    measurementId: 'G-1SXVE290S8',
  );

  // Remplacez les valeurs ci-dessous après `flutterfire configure`.

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2KAf1ncObUqus9kaoqIA9cHhZOD3BpVc',
    appId: '1:511053793923:android:0515df2ee7c1adc86de9b6',
    messagingSenderId: '511053793923',
    projectId: 'stock-flutter-c3552',
    storageBucket: 'stock-flutter-c3552.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    storageBucket: 'REPLACE_ME',
    iosBundleId: 'com.vipcoding.stockFlutter',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCPy74NmJE_cil1mk098hCXf9tw859DDX8',
    appId: '1:511053793923:web:36e9d5fbbe326bff6de9b6',
    messagingSenderId: '511053793923',
    projectId: 'stock-flutter-c3552',
    authDomain: 'stock-flutter-c3552.firebaseapp.com',
    storageBucket: 'stock-flutter-c3552.firebasestorage.app',
    measurementId: 'G-DL1CCQ6DLN',
  );

}