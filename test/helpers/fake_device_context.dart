import 'package:wardrobe_app/features/profile/domain/device_context.dart';

/// Fixed device / app version for tests.
class FakeDeviceContext implements DeviceContext {
  const FakeDeviceContext({
    this.device = 'Pixel 8 (Android 14)',
    this.appVersion = '1.0.0+1',
  });

  final String? device;
  final String? appVersion;

  @override
  Future<DeviceAppInfo> load() async {
    return DeviceAppInfo(device: device, appVersion: appVersion);
  }
}
