import "package:firebase_core/firebase_core.dart";
import "package:flutter/cupertino.dart";
import "package:huawei_push/huawei_push.dart";
import "package:jack_notification/src/model/notification_config.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:rxdart/subjects.dart";

class HCMNotificationConfig extends NotificationConfig {
  @override
  Future<void> init({
    required FirebaseOptions options,
    required NotificationConfig hcmNotification,
    required BehaviorSubject<(String, NotificationServiceType)> tokeStream,
    void Function(NotificationMessage message)? onMessageListen,
    void Function(NotificationMessage message)? onMessageOpened,
    String? vapidKey,
  }) async {
    Push.getToken("");

    Push.getTokenStream.listen((event) {
      tokeStream.add((event, NotificationServiceType.huawei));
    });

    Push.onMessageReceivedStream.listen((event) {
      onMessageListen?.call(
        NotificationMessage(
          data: event.dataOfMap,
          title: event.notification?.title,
          body: event.notification?.body,
        ),
      );
    });

    Push.onNotificationOpenedApp.listen((event) {
      // TODO(jackwill): check event type
      debugPrint(
        "----------------------huawei noti opened ${event.toString()}----------------------",
      );
      onMessageOpened?.call(
        NotificationMessage(
          data: (event as RemoteMessage).dataOfMap,
          title: event.notification?.title,
          body: event.notification?.body,
        ),
      );
    });
  }

  @override
  Future<NotificationMessage?> onMessageTerminatedOpen() async {
    final RemoteMessage? initialMessage = await Push.getInitialNotification();

    return initialMessage == null
        ? null
        : NotificationMessage(
            data: initialMessage.dataOfMap,
            title: initialMessage.notification?.title,
            body: initialMessage.notification?.body,
          );
  }
}
