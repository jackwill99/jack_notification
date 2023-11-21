import "package:firebase_core/firebase_core.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:jack_notification/src/notification_service.dart";

class JackNotification {
  JackNotification({
    required FirebaseOptions options,
    String? vapidKey,
  }) {
    _service = NotificationService(options: options, vapidKey: vapidKey);
  }

  late NotificationServiceInterface _service;

  Stream<(String token, NotificationServiceType service)> get getTokenStream =>
      _service.getTokenStream;

  /// Fake firebase options
  ///
  static const _options = FirebaseOptions(
    apiKey: "",
    appId: "",
    messagingSenderId: "",
    projectId: "",
  );

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
    required Future<void> Function(dynamic message) callBack,
  }) async {
    final backgroundService = NotificationService.backgroundProcess(
      options: _options,
    );

    await backgroundService.onFcmMessageBackground(callBack);
  }

  /// To listen the notification when the app is in terminated state
  ///
  static Future<void> onHcmMessageBackground({
    required Future<void> Function(dynamic message) callBack,
  }) async {
    final backgroundService = NotificationService.backgroundProcess(
      options: _options,
    );

    await backgroundService.onHcmMessageBackground(callBack);
  }
}
