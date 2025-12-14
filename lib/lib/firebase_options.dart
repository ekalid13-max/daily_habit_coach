// هذا الملف تم إنشاؤه يدوياً باستخدام بيانات ملف google-services.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS platforms are not yet supported for this project.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_r_fMof_AWhc9hORezn_or6soU16y7bM',
    appId: '1:690523525192:android:2d336bb20ef353b770487d',
    messagingSenderId: '690523525192',
    projectId: 'dailyhabitcoach-9660c',
    storageBucket: 'dailyhabitcoach-9660c.firebasestorage.app',
  );
}
