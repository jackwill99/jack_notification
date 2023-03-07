import 'package:firebase_messaging/firebase_messaging.dart';

void openedShowNotification(
  RemoteMessage message,
) {
  print("----------------------message----------------------");
  print('A new onMessageOpenedApp event was published!');
}
