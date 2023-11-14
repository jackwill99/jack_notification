## Jack Notification

This package is notification for flutter projects. So, you will need to set up notification
configuration.

### Firebase Cloud Messaging (FCM)

First, run below command to setup firebase options

```shell
flutterfire configure
```

And, initialize firebase options in `main` method,

```dart
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint(
    "........--------------message is------------${message.data}----------------------------......",
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}
```

Then, setup firebase configuration including listen incoming message or opening message for `active application state` by using `jack_notification` package.

```dart
final fcmConfig = JackFCMConfig(
    onMessageListen: (message){},
    onMessageOpened: (message){},
);

fcmConfig.firebaseSetup(vapidKey:"VapidKey");
```

For message opening in terminated state,

```dart
  await JackFCMConfig.onMessageTerminatedOpen();
```