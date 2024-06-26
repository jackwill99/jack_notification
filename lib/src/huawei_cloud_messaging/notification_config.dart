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
      final Map<String, dynamic>? message = event;
      callBack.call(
        NotificationMessage(
          data: message == null ? null : message["extras"],
        ),
      );
    });
  }

  @override
  Future<NotificationMessage?> getInitialNotification() async {
    final Map? initialMessage = await Push.getInitialNotification();
    if (initialMessage != null) {
      debugPrint(
        "-----------initialMessage---------------------${initialMessage["extras"]}--------------------------------",
      );
    }
    // final RemoteMessage? initialMessage = await Push.getInitialNotification();

    return initialMessage == null
        ? null
        : NotificationMessage(
            data: 
                 _convertToStringDynamicMap(initialMessage["extras"]),
          );
  }

  Map<String, dynamic>? _convertToStringDynamicMap(Map<Object?, Object?> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      if (key is String) {
        result[key] = value;
      }
    });
    return result;
  }

  @override
  Future<void> onFcmMessageBackground(
    void Function(FcmRemoteMessage message) callBack,
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
