// Archivo generado manualmente para inicializar Firebase en Flutter
// Basado en tu configuración real de Firebase Web.

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
      default:
        throw UnsupportedError(
          'FirebaseOptions no está configurado para esta plataforma.',
        );
    }
  }

  // 🔵 WEB
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAGSZp8T3y3s0A8hwKjrc6vVuar6WyCEvI",
    authDomain: "vozmefit.firebaseapp.com",
    projectId: "vozmefit",
    storageBucket: "vozmefit.firebasestorage.app",
    messagingSenderId: "966539970399",
    appId: "1:966539970399:web:efaea7af5ee71d1a6b98ea",
    measurementId: "G-TM29TSLEQV",
  );

  // 🟢 ANDROID
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAGSZp8T3y3s0A8hwKjrc6vVuar6WyCEvI",
    appId: "1:966539970399:android:efaea7af5ee71d1a6b98ea",
    messagingSenderId: "966539970399",
    projectId: "vozmefit",
    storageBucket: "vozmefit.firebasestorage.app",
  );

  // 🍎 iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAGSZp8T3y3s0A8hwKjrc6vVuar6WyCEvI",
    appId: "1:966539970399:ios:efaea7af5ee71d1a6b98ea",
    messagingSenderId: "966539970399",
    projectId: "vozmefit",
    storageBucket: "vozmefit.firebasestorage.app",
    iosBundleId: "com.vozmefit.app",
  );

  // 🍏 macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyAGSZp8T3y3s0A8hwKjrc6vVuar6WyCEvI",
    appId: "1:966539970399:macos:efaea7af5ee71d1a6b98ea",
    messagingSenderId: "966539970399",
    projectId: "vozmefit",
    storageBucket: "vozmefit.firebasestorage.app",
    iosBundleId: "com.vozmefit.app",
  );
}
