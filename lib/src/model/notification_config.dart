import "package:firebase_core/firebase_core.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:rxdart/subjects.dart";

abstract class NotificationConfig {
  /// Initialize the notification
  Future<void> init({
    required FirebaseOptions options,
    required NotificationConfig hcmNotification,
    required BehaviorSubject<(String, NotificationServiceType)> tokeStream,
    void Function(NotificationMessage message)? onMessageListen,
    void Function(NotificationMessage message)? onMessageOpened,
    String? vapidKey,
  });

  /// It is assumed that all messages contain a data field with the key 'type'
  /// call this method in application initial cycle and if initialMessage ,
  /// Get any messages which caused the application to open from
  /// a terminated state.
  Future<NotificationMessage?> onMessageTerminatedOpen();
}
