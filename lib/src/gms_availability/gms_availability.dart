import "package:jack_notification/src/gms_availability/gms_availability_platform_interface.dart";

class GoogleMessagingServiceAvailability {
  Future<bool> isGmsAvailable() {
    return GoogleMessagingServicePlatform.instance.isGmsAvailable();
  }
}
