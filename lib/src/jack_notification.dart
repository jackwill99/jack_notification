import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:huawei_push/huawei_push.dart" as huawei;
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:jack_notification/src/notification_service.dart";

class JackNotification {
  JackNotification({
    required FirebaseOptions options,
    String? vapidKey,
  }) {
    _vapidKey = vapidKey;
    _options = options;
  }

  late NotificationServiceInterface _service;
  late FirebaseOptions _options;
  String? _vapidKey;

  Stream<(String token, NotificationServiceType service)> get getTokenStream =>
      _service.getTokenStream;

  /// Mock firebase options
  ///
  static const _mockOptions = FirebaseOptions(
    apiKey: "",
    appId: "",
    messagingSenderId: "",
    projectId: "",
  );

  Future<void> init() async {
    _service = NotificationService(options: _options, vapidKey: _vapidKey);
    await _service.setup();
  }

  /// Check google messaging service available or not
  Future<bool> checkGmsAvailable() async {
    return _service.checkGmsAvailable();
  }

  /// When an incoming Notification instant messaging is received whilst the Flutter instance is in the foreground.
  ///
  void onMessageListen(
    void Function(NotificationMessage message) onMessageListen,
  ) {
    _service.onMessageListen(onMessageListen);
  }

  /// When a user presses a notification message displayed via Notification instant Messaging.
  ///
  void onMessageOpened(
    void Function(NotificationMessage message) onMessageOpened,
  ) {
    _service.onMessageOpened(onMessageOpened);
  }

  /// It is assumed that all messages contain a data field with the key 'type'
  /// call this method in application initial cycle and if initialMessage , do ur actions
  /// Initial notification message from the terminated state of app
  Future<NotificationMessage?> getInitialNotification() async {
    return _service.getInitialNotification();
  }

  static Future<void> fcmInitialize(FirebaseOptions options) async {
    await Firebase.initializeApp(options: options);
  }

  /// To listen the notification when the app is in terminated state
  ///
  static Future<void> onFcmMessageBackground({
    required Future<void> Function(RemoteMessage message) callBack,
  }) async {
    final backgroundService = NotificationService.backgroundProcess(
      options: _mockOptions,
    );

    await backgroundService.onFcmMessageBackground(callBack);
  }

  /// To listen the notification when the app is in terminated state
  ///
  static Future<void> onHcmMessageBackground({
    required Future<void> Function(huawei.RemoteMessage message) callBack,
  }) async {
    final backgroundService = NotificationService.backgroundProcess(
      options: _mockOptions,
    );

    await backgroundService.onHcmMessageBackground(callBack);
  }
}
