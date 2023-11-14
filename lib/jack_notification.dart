
import 'jack_notification_platform_interface.dart';

class JackNotification {
  Future<String?> getPlatformVersion() {
    return JackNotificationPlatform.instance.getPlatformVersion();
  }
}
