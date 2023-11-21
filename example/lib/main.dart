import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jack_notification/jack_notification.dart';
import 'package:jack_notification_example/firebase_options.dart';

/// firebase
@pragma("vm:entry-point")
Future<void> fcmRemoteMessage(message) async {
  final remoteMessage = message as FCMRemoteMessage;
  debugPrint(
      "----------------------firebase background remote message----------------------");
  print(remoteMessage.data);
}

/// huawei
@pragma("vm:entry-point")
Future<void> hcmRemoteMessage(message) async {
  final remoteMessage = message as RemoteMessage;
  debugPrint(
      "----------------------huawei background remote message----------------------");
  print(remoteMessage.dataOfMap);
}

void main() {
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

    JackNotification.onFcmMessageBackground(callBack: fcmRemoteMessage);
    JackNotification.onHcmMessageBackground(callBack: hcmRemoteMessage);
  }

  Future<void> initPlatformState() async {
    final a = JackNotification(options: DefaultFirebaseOptions.currentPlatform);
    a.onMessageListen((message) {
      debugPrint(
          "----------------------onmessage listen $message----------------------");
    });
    a.getTokenStream.listen((value) {
      debugPrint(
          "----------------------token ${value.$1}-------service ${value.$2}---------------");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: '),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final random = Random().nextInt(10);
            notification.showNotification(
                id: random, title: "Notification", body: "test");
          },
          child: Icon(Icons.notifications_active),
        ),
      ),
    );
  }
}
