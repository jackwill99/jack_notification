import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jack_notification_method_channel.dart';

abstract class JackNotificationPlatform extends PlatformInterface {
  /// Constructs a JackNotificationPlatform.
  JackNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static JackNotificationPlatform _instance = MethodChannelJackNotification();

  /// The default instance of [JackNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelJackNotification].
  static JackNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JackNotificationPlatform] when
  /// they register themselves.
  static set instance(JackNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
