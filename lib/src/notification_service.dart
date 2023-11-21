import "dart:async";
import "dart:io";

import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:jack_notification/src/firebase_cloud_messaging/notification_config.dart";
import "package:jack_notification/src/gms_availability/gms_availability.dart";
import "package:jack_notification/src/huawei_cloud_messaging/notification_config.dart";
import "package:jack_notification/src/model/notification_config.dart";
import "package:jack_notification/src/model/notification_message.dart";
import "package:jack_notification/src/model/notification_service_interface.dart";
import "package:rxdart/subjects.dart";

class NotificationService extends NotificationServiceInterface {
  NotificationService({
    required FirebaseOptions options,
    String? vapidKey,
  }) {
    unawaited(_setup(options: options, vapidKey: vapidKey));
    getTokenStream = _tokeStream.stream;
  }

  final _googleMessagingServiceAvailability =
      GoogleMessagingServiceAvailability();

  /// Notification Service
  final NotificationConfig _fcmNotificationConfig = FCMNotificationConfig();
  final NotificationConfig _hcmNotificationConfig = HCMNotificationConfig();

  /// Stream Token
  ///
  final _tokeStream =
      BehaviorSubject<(String token, NotificationServiceType service)>();

  Future<void> _setup({
    required FirebaseOptions options,
    String? vapidKey,
  }) async {
    final gmsAvailable = await checkGmsAvailable();

    assert(
      !(gmsAvailable && kIsWeb) || vapidKey != null,
      "This device support google messaging service. So, you need vapidKey.",
    );

    if (gmsAvailable) {
      unawaited(
        _fcmNotificationConfig.init(
          options: options,
          hcmNotification: _hcmNotificationConfig,
          tokeStream: _tokeStream,
          vapidKey: vapidKey,
        ),
      );
    } else {
      unawaited(
        _hcmNotificationConfig.init(
          options: options,
          hcmNotification: _hcmNotificationConfig,
          tokeStream: _tokeStream,
          vapidKey: vapidKey,
        ),
      );
    }
  }

  @override
  Future<bool> checkGmsAvailable() async {
    if (Platform.isIOS) {
      return true;
    }

    if (isGmsAvailable == null) {
      final gmsAvailable =
          await _googleMessagingServiceAvailability.isGmsAvailable();
      isGmsAvailable = gmsAvailable;

      return gmsAvailable;
    }

    return isGmsAvailable!;
  }

  @override
  Future<NotificationMessage?> onMessageTerminatedOpen() async {
    final gmsAvailable = await checkGmsAvailable();

    if (gmsAvailable) {
      return _fcmNotificationConfig.onMessageTerminatedOpen();
    }

    return _hcmNotificationConfig.onMessageTerminatedOpen();
  }

  @override
  Future<void> onMessageListen(
    void Function(NotificationMessage message) callBack,
  ) async {
    final gmsAvailable = await checkGmsAvailable();

    if (gmsAvailable) {
      _fcmNotificationConfig.onMessageListen(callBack);
    } else {
      _hcmNotificationConfig.onMessageListen(callBack);
    }
  }

  @override
  Future<void> onMessageOpened(
    void Function(NotificationMessage message) callBack,
  ) async {
    final gmsAvailable = await checkGmsAvailable();

    if (gmsAvailable) {
      _fcmNotificationConfig.onMessageOpened(callBack);
    } else {
      _hcmNotificationConfig.onMessageOpened(callBack);
    }
  }
}
