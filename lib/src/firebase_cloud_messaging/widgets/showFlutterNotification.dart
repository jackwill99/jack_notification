import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jack_notification/src/firebase_cloud_messaging/providers/fcm_notification_config.dart';
// import 'package:jack_components/core_system/fcmANDnotification/providers/fcm_notification_provider.dart';

void showFlutterNotification(RemoteMessage message) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      JackFCMNotificationConfig.flutterLocalNotificationsPlugin;
  AndroidNotificationChannel channel = JackFCMNotificationConfig.channel;
  RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  print(
      "----------------------showflutter notifications----------------------");
  print(message.notification?.apple);
  if (notification != null && !kIsWeb) {
    flutterLocalNotificationsPlugin
        .show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/ic_launcher',
        ),
      ),
    )
        .then((value) async {
      print("----------------------notification message----------------------");
      final messageData = message.data;
      print(messageData);
      messageData.forEach((key, value) {
        print(key);
        print(value.runtimeType);
        print(value);
      });
    });
  }
}
