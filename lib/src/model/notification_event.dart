import "package:jack_notification/jack_notification.dart";

abstract class NotificationEvent {
  /// When an incoming Notification instant messaging is received whilst the Flutter instance is in the foreground.
  ///
  void onMessageListen(void Function(NotificationMessage message) callBack);

  /// When a user presses a notification message displayed via Notification instant Messaging.
  ///
  void onMessageOpened(void Function(NotificationMessage message) callBack);

  /// It is assumed that all messages contain a data field with the key 'type'
  /// call this method in application initial cycle and if initialMessage ,
  /// Get any messages which caused the application to open from
  /// a terminated state.
  Future<NotificationMessage?> getInitialNotification();

  /// To listen the notification when the app is in terminated state
  ///
  Future<void> onFcmMessageBackground(
    Future<void> Function(FcmRemoteMessage message) callBack,
  );

  /// To listen the notification when the app is in terminated state
  ///
  Future<void> onHcmMessageBackground(
    void Function(HcmRemoteMessage message) callBack,
  );
}
