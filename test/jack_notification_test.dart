import 'package:flutter_test/flutter_test.dart';
import 'package:jack_notification/jack_notification.dart';
import 'package:jack_notification/jack_notification_platform_interface.dart';
import 'package:jack_notification/jack_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJackNotificationPlatform
    with MockPlatformInterfaceMixin
    implements JackNotificationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final JackNotificationPlatform initialPlatform = JackNotificationPlatform.instance;

  test('$MethodChannelJackNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJackNotification>());
  });

  test('getPlatformVersion', () async {
    JackNotification jackNotificationPlugin = JackNotification();
    MockJackNotificationPlatform fakePlatform = MockJackNotificationPlatform();
    JackNotificationPlatform.instance = fakePlatform;

    expect(await jackNotificationPlugin.getPlatformVersion(), '42');
  });
}
