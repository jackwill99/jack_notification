import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jack_notification/jack_notification.dart';
import 'package:jack_notification_example/firebase_options.dart';

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

  /// firebase
  Future<void> fcmRemoteMessage(message) async {
    final remoteMessage = message as FCMRemoteMessage;
    print(remoteMessage.data);
  }

  /// huawei
  Future<void> hcmRemoteMessage(message) async {
    final remoteMessage = message as RemoteMessage;
    print(remoteMessage.dataOfMap);
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
