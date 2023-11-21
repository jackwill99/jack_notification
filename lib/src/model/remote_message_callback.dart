import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart" as firebase;
import "package:huawei_push/huawei_push.dart" as huawei;
import "package:jack_notification/jack_notification.dart";

@pragma("vm:entry-point")
class RemoteMessageCallBack {
  factory RemoteMessageCallBack() {
    return I;
  }

  RemoteMessageCallBack._();

  static final RemoteMessageCallBack I = RemoteMessageCallBack._();

  late FirebaseOptions firebaseOptions;

  late void Function(NotificationMessage message) hcmRemoteMessageCallback;

  late void Function(NotificationMessage message) fcmRemoteMessageCallback;
}

@pragma("vm:entry-point")
Future<void> hcmRemoteMessaging(
  huawei.RemoteMessage remoteMessage,
) async {
  final message = NotificationMessage(
    data: remoteMessage.dataOfMap,
    title: remoteMessage.notification?.title,
    body: remoteMessage.notification?.body,
  );
  final messageCallback = RemoteMessageCallBack();
  await Firebase.initializeApp(options: messageCallback.firebaseOptions);
  messageCallback.hcmRemoteMessageCallback(message);
}

@pragma("vm:entry-point")
Future<void> fcmRemoteMessaging(
  firebase.RemoteMessage remoteMessage,
) async {
  final message = NotificationMessage(
    data: remoteMessage.data,
    title: remoteMessage.notification?.title,
    body: remoteMessage.notification?.body,
  );
  RemoteMessageCallBack().fcmRemoteMessageCallback(message);
}
