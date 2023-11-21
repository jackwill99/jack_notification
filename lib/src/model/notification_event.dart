import "package:jack_notification/src/model/notification_message.dart";

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
  Future<void> onMessageBackground(void Function(NotificationMessage message) callBack);
}
