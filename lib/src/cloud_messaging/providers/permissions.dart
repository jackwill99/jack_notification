import "package:firebase_messaging/firebase_messaging.dart";

Future<void> requestPermission() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings =
  await messaging.requestPermission();

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }
}
