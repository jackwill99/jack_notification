import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";

class JackFCMNotificationConfig {
  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  /// setup notification plugin
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isFlutterLocalNotificationsInitialized = false;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    /// setup notification channel
    channel = const AndroidNotificationChannel(
      "high_importance_channel", // id
      "High Importance Notifications", // title
      description:
          "This channel is used for important notifications.", // description
      importance: Importance.max,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

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
}
