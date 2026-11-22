import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local_storage.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static String? _fcmToken;

  static Future<void> init() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    // FCM
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _fcmToken = await _fcm.getToken();
    await LocalStorage.setFcmToken(_fcmToken ?? '');

    // Listen to token refresh
    FirebaseMessaging.onTokenRefresh.listen((token) async {
      _fcmToken = token;
      await LocalStorage.setFcmToken(token);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
        title: message.notification?.title ?? 'KiliCart',
        body: message.notification?.body ?? '',
        data: message.data,
      );
    });

    // Background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static String? get fcmToken => _fcmToken;

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'kilicart_flash_sale',
      'Flash Sales',
      channelDescription: 'KiliCart flash sale and price drop alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: 0xFFFF6B00,
    );
    const details = NotificationDetails(android: androidDetails);
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  static Future<void> showFlashSaleNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _showLocalNotification(title: title, body: body, data: data);
  }
}

import 'dart:convert';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background handler - no UI access
}
