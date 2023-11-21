import "package:jack_notification/src/gms_availability/gms_availability_method_channel.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

abstract class GoogleMessagingServicePlatform extends PlatformInterface {
  /// Constructs a JackNotificationPlatform.
  GoogleMessagingServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static GoogleMessagingServicePlatform _instance =
      MethodChannelGoogleMessagingService();

  /// The default instance of [GoogleMessagingServicePlatform] to use.
  ///
  /// Defaults to [MethodChannelGoogleMessagingService].
  static GoogleMessagingServicePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GoogleMessagingServicePlatform] when
  /// they register themselves.
  static set instance(GoogleMessagingServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isGmsAvailable() {
    throw UnimplementedError("platformVersion() has not been implemented.");
  }
}
