import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  Future<void> init(String userId) async {
    // طلب إذن الإشعارات
    await _fcm.requestPermission();
    
    // حفظ رمز الجهاز (token) في Firestore
    final token = await _fcm.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
    }

    // إعداد الإشعارات المحلية
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: ios);
    await _local.initialize(initSettings);
  }

  Future<void> showLocalNotification(String title, String body) async {
    final android = AndroidNotificationDetails(
        'daily_channel', 'Daily Reminders',
        importance: Importance.high, priority: Priority.high);
    final platform = NotificationDetails(android: android);
    await _local.show(0, title, body, platform);
  }
}
