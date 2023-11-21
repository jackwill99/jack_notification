import "package:jack_notification/src/model/notification_message.dart";

abstract class NotificationServiceInterface {
  /// Checking this device will support google messaging service or not
  bool? isGmsAvailable;

  /// Token Stream
  ///
  late Stream<(String token, NotificationServiceType service)> getTokenStream;

  /// Set [onMessageListen] of the notification service
  ///
  abstract void Function(NotificationMessage message)? onMessageListen;

  /// When you are receiving a notification with **notification channel**, ios will show default notification of firebase instant messaging but won't in android. If you want to listen the clicked event of this situation of ios, use this method [onMessageOpened]
  abstract void Function(NotificationMessage message)? onMessageOpened;

  /// Check google messaging service available or not
  Future<bool> checkGmsAvailable();

  /// It is assumed that all messages contain a data field with the key 'type'
  /// call this method in application initial cycle and if initialMessage , do ur actions
  /// Initial notification message from the terminated state of app
  Future<NotificationMessage?> onMessageTerminatedOpen();
}

enum NotificationServiceType {
  firebase,
  huawei,
}
