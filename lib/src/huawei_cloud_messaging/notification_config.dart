import "package:firebase_core/firebase_core.dart";
import "package:flutter/cupertino.dart";
import "package:huawei_push/huawei_push.dart";
import "package:jack_notification/src/model/notification_config.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:jack_notification/src/model/remote_message.dart";
import "package:rxdart/subjects.dart";

class HCMNotificationConfig extends NotificationConfig {
  @override
  Future<void> init({
    required FirebaseOptions options,
    required NotificationConfig hcmNotification,
    required BehaviorSubject<(String, NotificationServiceType)> tokeStream,
    String? vapidKey,
  }) async {
    Push.getToken("");

    Push.getTokenStream.listen((event) {
      tokeStream.add((event, NotificationServiceType.huawei));
    });
  }

  @override
  void onMessageListen(void Function(NotificationMessage message) callBack) {
    Push.onMessageReceivedStream.listen((event) {
      debugPrint(
        "----------------------Huawei OnMessageListen----------------------",
      );
      callBack.call(
        NotificationMessage(
          data: event.dataOfMap,
          title: event.notification?.title,
          body: event.notification?.body,
        ),
      );
    });
  }

  @override
  void onMessageOpened(void Function(NotificationMessage message) callBack) {
    Push.onNotificationOpenedApp.listen((event) {
      // TODO(jackwill): check event type
      debugPrint(
        "----------------------Huawei OnMessageOpened ${event.toString()}----------------------",
      );
      callBack.call(
        NotificationMessage(
          data: (event as RemoteMessage).dataOfMap,
          title: event.notification?.title,
          body: event.notification?.body,
        ),
      );
    });
  }

  @override
  Future<NotificationMessage?> getInitialNotification() async {
    final RemoteMessage? initialMessage = await Push.getInitialNotification();

    return initialMessage == null
        ? null
        : NotificationMessage(
            data: initialMessage.dataOfMap,
            title: initialMessage.notification?.title,
            body: initialMessage.notification?.body,
          );
  }

  @override
  Future<void> onFcmMessageBackground(
    void Function(FCMRemoteMessage message) callBack,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> onHcmMessageBackground(
    void Function(RemoteMessage message) callBack,
  ) async {
    await Push.registerBackgroundMessageHandler(callBack);
  }
}
