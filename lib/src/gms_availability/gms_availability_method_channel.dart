import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:jack_notification/src/gms_availability/gms_availability_platform_interface.dart";

/// An implementation of [MethodChannelGoogleMessagingService] that uses method channels.
class MethodChannelGoogleMessagingService
    extends GoogleMessagingServicePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel("jack_notification");

  @override
  Future<bool> isGmsAvailable() async {
    final version = await methodChannel.invokeMethod<bool>("isGmsAvailable");
    if (version == null) {
      debugPrint(
        "isGmsAvailable default false----------------------",
      );
    }
    return version ?? false;
  }
}
