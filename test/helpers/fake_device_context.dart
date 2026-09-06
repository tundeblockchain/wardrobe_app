import 'package:wardrobe_app/features/profile/domain/device_context.dart';

/// Fixed WARDROBE-38 `meta` fields for tests.
class FakeDeviceContext implements DeviceContext {
  const FakeDeviceContext({
    this.appVersion = '1.0.0+1',
    this.platform = 'android',
    this.deviceModel = 'Pixel 8',
    this.osVersion = '14',
  });

  final String? appVersion;
  final String? platform;
  final String? deviceModel;
  final String? osVersion;

  @override
  Future<DeviceAppInfo> load() async {
    return DeviceAppInfo(
      appVersion: appVersion,
      platform: platform,
      deviceModel: deviceModel,
      osVersion: osVersion,
    );
  }
}
