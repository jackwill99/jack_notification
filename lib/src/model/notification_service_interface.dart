import "package:jack_notification/src/model/notification_event.dart";

abstract class NotificationServiceInterface extends NotificationEvent {
  /// Checking this device will support google messaging service or not
  bool isGmsAvailable = true;

  /// Token Stream
  ///
  late Stream<(String token, NotificationServiceType service)> getTokenStream;

  /// Initialization the instance
  Future<void> setup();

  /// Check google messaging service available or not
  Future<bool> checkGmsAvailable();
}

enum NotificationServiceType {
  firebase,
  huawei,
}
