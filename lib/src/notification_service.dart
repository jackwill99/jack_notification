import "dart:async";
import "dart:io";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:jack_notification/src/firebase_cloud_messaging/notification_config.dart";
import "package:jack_notification/src/gms_availability/gms_availability.dart";
import "package:jack_notification/src/huawei_cloud_messaging/notification_config.dart";
import "package:jack_notification/src/model/notification_config.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:jack_notification/src/model/remote_message.dart";
import "package:rxdart/subjects.dart";

class NotificationService extends NotificationServiceInterface {
  NotificationService({
    required FirebaseOptions options,
    String? vapidKey,
  }) {
    _options = options;
    _vapidKey = vapidKey;

    getTokenStream = _tokeStream.stream;
  }

  factory NotificationService.backgroundProcess({
    required FirebaseOptions options,
    String? vapidKey,
  }) {
    final instance = NotificationService(
      options: options,
      vapidKey: vapidKey,
    );
    return instance;
  }

  final _googleMessagingServiceAvailability =
      GoogleMessagingServiceAvailability();

  /// Instance properties
  ///
  late FirebaseOptions _options;
  String? _vapidKey;

  /// Notification Service
  final NotificationConfig _fcmNotificationConfig = FCMNotificationConfig();
  final NotificationConfig _hcmNotificationConfig = HCMNotificationConfig();

  /// Stream Token
  ///
  final _tokeStream =
      BehaviorSubject<(String token, NotificationServiceType service)>();

  @override
  Future<void> setup() async {
    final gmsAvailable = await checkGmsAvailable();

    assert(
      !(gmsAvailable && kIsWeb) || _vapidKey != null,
      "This device support google messaging service. So, you need vapidKey.",
    );

    if (gmsAvailable) {
      await _fcmNotificationConfig.init(
        options: _options,
        hcmNotification: _hcmNotificationConfig,
        tokeStream: _tokeStream,
        vapidKey: _vapidKey,
      );
    } else {
      await _hcmNotificationConfig.init(
        options: _options,
        hcmNotification: _hcmNotificationConfig,
        tokeStream: _tokeStream,
      );
    }
  }

  @override
  Future<bool> checkGmsAvailable() async {
    if (Platform.isIOS) {
      return true;
    }

    final gmsAvailable =
        await _googleMessagingServiceAvailability.isGmsAvailable();
    isGmsAvailable = gmsAvailable;

    return gmsAvailable;
  }

  @override
  Future<void> onMessageListen(
    void Function(NotificationMessage message) callBack,
  ) async {
    if (isGmsAvailable) {
      _fcmNotificationConfig.onMessageListen(callBack);
    } else {
      _hcmNotificationConfig.onMessageListen(callBack);
    }
  }

  @override
  Future<void> onMessageOpened(
    void Function(NotificationMessage message) callBack,
  ) async {
    if (isGmsAvailable) {
      _fcmNotificationConfig.onMessageOpened(callBack);
    } else {
      _hcmNotificationConfig.onMessageOpened(callBack);
    }
  }

  @override
  Future<NotificationMessage?> getInitialNotification() async {
    if (isGmsAvailable) {
      return _fcmNotificationConfig.getInitialNotification();
    }

    return _hcmNotificationConfig.getInitialNotification();
  }

  @override
  Future<void> onFcmMessageBackground(
    Future<void> Function(RemoteMessage message) callBack,
  ) async {
    if (isGmsAvailable) {
      await _fcmNotificationConfig.onFcmMessageBackground(callBack);
    }
  }

  @override
  Future<void> onHcmMessageBackground(
    void Function(HcmRemoteMessage message) callBack,
  ) async {
    if (Platform.isAndroid && !isGmsAvailable) {
      await _hcmNotificationConfig.onHcmMessageBackground(callBack);
    }
  }
}
