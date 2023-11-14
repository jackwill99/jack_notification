import "dart:async";

import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:jack_notification/src/cloud_messaging/providers/fcm_notification_config.dart";
import "package:jack_notification/src/cloud_messaging/providers/permissions.dart";

class JackFCMConfig {
  JackFCMConfig({required this.onMessageListen, required this.onMessageOpened});

  late void Function(RemoteMessage message) onMessageListen;
  late void Function(RemoteMessage message) onMessageOpened;
  final fcmNotificationConfig = JackFCMNotificationConfig();

  Future<String?> firebaseSetup({required String vapidKey}) async {
    await requestPermission();
    String? token;

    if (!kIsWeb) {
      /// Local Notification setup
      await fcmNotificationConfig.setupFlutterNotifications();
    }

    try {
      await FirebaseMessaging.instance.getToken(vapidKey: vapidKey).then(
        (value) {
          debugPrint("----------------------token----------------------");
          debugPrint(value);
          token = value;
          // _setupToken.add(value);
          // setupToken.addToken(value);
        },
      );
    } catch (e) {
      // TODO(jackwill): Huawei Messaging Service
      debugPrint("----------------------token $e----------------------");
    }

    /// if u need uncomment this
    // _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    // _tokenStream.listen(_setupToken.add);
    FirebaseMessaging.onMessage.listen((message) {
      onMessageListen(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onMessageOpened(message);
    });

    return token;
  }

  /// It is assumed that all messages contain a data field with the key 'type'
  /// call this method in application initial cycle and if initialMessage , do ur actions
  static Future<RemoteMessage?> onMessageTerminatedOpen() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    return initialMessage;
  }
}
