import "dart:async";
import "dart:convert";

import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:http/http.dart" as http;
import "package:rxdart/subjects.dart";

class JackLocalNotificationApi {
  JackLocalNotificationApi() {
    unawaited(_init());
  }

  final _notifications = FlutterLocalNotificationsPlugin();
  final _onNotifications = BehaviorSubject<NotificationResponse>();
  final _onKilledNotifications =
      BehaviorSubject<NotificationAppLaunchDetails>();

  Future<void> _channelSetup() async {
    /// Initialize the [FlutterLocalNotificationsPlugin] package.
    /// Create a [AndroidNotificationChannel] for heads up notifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
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
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _init({bool initScheduled = false}) async {
    /// Create Notification Channel
    // await _channelSetup();

    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    /// when app is killed and opened by clicking notification
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      /// listening clicked LocalNotification when app is killed
      _onKilledNotifications.add(details);
    }

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        _onNotifications.add(details);
      },
    );
  }

  Future<NotificationDetails> _notificationDetails({
    String? iconPath,
    String? imagePath,
    String? sound,
  }) async {
    /// local notification with Icon and Image
    http.Response? imageResponse;
    http.Response? iconResponse;

    if (imagePath != null) {
      imageResponse = await http.get(Uri.parse(imagePath));
    }
    if (iconPath != null) {
      iconResponse = await http.get(Uri.parse(iconPath));
    }

    final styleInformation = imagePath != null
        ? BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(imageResponse!.bodyBytes),
            ),
            largeIcon: iconPath != null
                ? ByteArrayAndroidBitmap.fromBase64String(
                    base64Encode(iconResponse!.bodyBytes),
                  )
                : null,
          )
        : null;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        "high_importance_channel", // id
        "High Importance Notifications", // title
        channelDescription: "This channel is used for important notifications.",
        // description
        importance: Importance.max,
        styleInformation: styleInformation,
        sound: sound != null
            ? RawResourceAndroidNotificationSound(sound.split(".").first)
            : null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        sound: sound,
      ),
    );
  }

  /// [iconPath], [imagePath], [soundPath] must be https url
  ///
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    String? iconPath,
    String? imagePath,
    String? soundPath,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(
        iconPath: iconPath,
        imagePath: imagePath,
        sound: soundPath,
      ),
      payload: payload,
    );
  }

  /// listening clicked LocalNotification
  Future<void> listenOpenedNotifications(
    Function(NotificationResponse value) callbackFunc,
  ) async =>
      _onNotifications.stream.listen(
        (event) {
          callbackFunc(event);
        },
      );

  /// listening clicked LocalNotification when app is killed
  Future<void> listenTerminatedNotifications(
    Function(NotificationAppLaunchDetails value) callbackFunc,
  ) async =>
      _onKilledNotifications.stream.listen(
        (event) {
          callbackFunc(event);
        },
      );

  Future<void> cancelNotifications({required int id}) async {
    await _notifications.cancel(id);
  }
}
