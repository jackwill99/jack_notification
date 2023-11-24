import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jack_notification/jack_notification.dart';
import 'package:jack_notification_example/firebase_options.dart';

/// firebase
@pragma("vm:entry-point")
Future<void> fcmRemoteMessage(message) async {
  await JackNotification.fcmInitialize(DefaultFirebaseOptions.currentPlatform);

  final remoteMessage = message as FcmRemoteMessage;
  message.toMap();
  debugPrint(
      "----------------------firebase background remote message----------------------");
  print(remoteMessage.data);
}

/// huawei
@pragma("vm:entry-point")
Future<void> hcmRemoteMessage(message) async {
  final remoteMessage = message as HcmRemoteMessage;
  debugPrint(
      "----------------------huawei background remote message----------------------");
  print(remoteMessage.dataOfMap);
}

void main() {
  JackNotification.onFcmMessageBackground(callBack: fcmRemoteMessage);
  JackNotification.onHcmMessageBackground(callBack: hcmRemoteMessage);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notification = JackLocalNotificationApi();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final jackNotification =
        JackNotification(options: DefaultFirebaseOptions.currentPlatform);
    await jackNotification.init();

    jackNotification.onMessageListen((message) {
      debugPrint(
          "----------------------onmessage listen $message----------------------");
    });
    jackNotification.onMessageOpened((message) {
      debugPrint(
          "----------------------onmessage opened $message----------------------");
    });
    jackNotification.getTokenStream.listen((value) {
      debugPrint(
          "----------------------token ${value.$1}-------service ${value.$2}---------------");
    });

    notification.listenOpenedNotifications((value) {
      debugPrint(
          "------------opened local notification----------${value.payload}----------------------");
    });

    notification.listenTerminatedNotifications((value) {
      debugPrint(
          "----------------------terminated local notification-------${value.didNotificationLaunchApp}---------------");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Running on: '),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final random = Random().nextInt(10);
            notification.showNotification(
              id: random,
              title: "Notification",
              body: "test",
              payload: "custom show notification",
            );
          },
          child: Icon(Icons.notifications_active),
        ),
      ),
    );
  }
}
