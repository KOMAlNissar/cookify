import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// INIT
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);

    await FirebaseMessaging.instance.requestPermission();
  }

  /// SHOW DAILY RECIPE NOTIFICATION
  static Future<void> showDailyRecipeNotification({
    required String recipeName,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_recipe',
      'Daily Recipe',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      "🍽 Today's Recipe",
      "Try cooking $recipeName today!",
      notificationDetails,
    );
  }

  /// LISTEN FOR PUSH (FCM)
  static void listenForPush() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showDailyRecipeNotification(
          recipeName: message.notification!.body ?? "New Recipe",
        );
      }
    });
  }
}
