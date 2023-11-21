import "dart:async";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/cupertino.dart";
import "package:huawei_push/huawei_push.dart" as huawei;
import "package:jack_notification/src/firebase_cloud_messaging/permissions.dart";
import "package:jack_notification/src/model/notification_config.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:rxdart/subjects.dart";

class FCMNotificationConfig extends NotificationConfig {
  bool isFlutterLocalNotificationsInitialized = false;

  late void Function(NotificationMessage message) _remoteMessageCallback;

  Future<void> _setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  @override
  Future<void> init({
    required FirebaseOptions options,
    required NotificationConfig hcmNotification,
    required BehaviorSubject<(String, NotificationServiceType)> tokeStream,
    String? vapidKey,
  }) async {
    debugPrint(
      "----------------------Trying Google Messaging Service----------------------",
    );
    await Firebase.initializeApp(options: options);
    await requestPermission();

    /// Local Notification setup
    await _setupFlutterNotifications();
    try {
      unawaited(
        FirebaseMessaging.instance.getToken(vapidKey: vapidKey).then((value) {
          debugPrint(
            "----------------------firebase token $value----------------------",
          );
          if (value != null) {
            tokeStream.add((value, NotificationServiceType.firebase));
          }
        }),
      );
    } catch (e) {
      debugPrint(
        "----------------------Failed Google Messaging Service & Trying Huawei Service----------------------",
      );

      unawaited(
        hcmNotification.init(
          options: options,
          hcmNotification: hcmNotification,
          tokeStream: tokeStream,
        ),
      );
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      tokeStream.add((event, NotificationServiceType.firebase));
    });
  }

  @override
  void onMessageListen(void Function(NotificationMessage message) callBack) {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
        "----------------------Firebase OnMessageListen----------------------",
      );
      callBack.call(
        NotificationMessage(
          data: message.data.isEmpty ? null : message.data,
          title: message.notification?.title,
          body: message.notification?.body,
        ),
      );
    });
  }

  @override
  void onMessageOpened(void Function(NotificationMessage message) callBack) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
        "----------------------Firebase OnMessageOpened----------------------",
      );
      callBack.call(
        NotificationMessage(
          data: message.data.isEmpty ? null : message.data,
          title: message.notification?.title,
          body: message.notification?.body,
        ),
      );
    });
  }

  @override
  Future<NotificationMessage?> getInitialNotification() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    return initialMessage == null
        ? null
        : NotificationMessage(
            data: initialMessage.data,
            title: initialMessage.notification?.title,
            body: initialMessage.notification?.body,
          );
  }

  @override
  Future<void> onFcmMessageBackground(
    Future<void> Function(RemoteMessage message) callBack,
  ) async {
    FirebaseMessaging.onBackgroundMessage(callBack);
  }

  @override
  Future<void> onHcmMessageBackground(
    void Function(huawei.RemoteMessage message) callBack,
  ) {
    throw UnimplementedError();
  }
}
