import "package:firebase_core/firebase_core.dart";
import "package:jack_notification/src/model/notification_event.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:rxdart/subjects.dart";

abstract class NotificationConfig extends NotificationEvent {
  /// Initialize the notification
  Future<void> init({
    required FirebaseOptions options,
    required NotificationConfig hcmNotification,
    required BehaviorSubject<(String, NotificationServiceType)> tokeStream,
    String? vapidKey,
  });
}
