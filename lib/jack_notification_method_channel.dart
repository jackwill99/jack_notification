import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jack_notification_platform_interface.dart';

/// An implementation of [JackNotificationPlatform] that uses method channels.
class MethodChannelJackNotification extends JackNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('jack_notification');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
