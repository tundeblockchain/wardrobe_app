import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/profile/domain/device_context.dart';

void main() {
  test('toMeta matches the WARDROBE-38 string-map shape', () {
    expect(
      const DeviceAppInfo(
        appVersion: '1.0.0',
        platform: 'ios',
        deviceModel: 'iPhone 15',
        osVersion: '18.1',
      ).toMeta(),
      {
        'appVersion': '1.0.0',
        'platform': 'ios',
        'deviceModel': 'iPhone 15',
        'osVersion': '18.1',
      },
    );
  });

  test('toMeta omits blank fields', () {
    expect(const DeviceAppInfo(appVersion: '1.0.0', platform: '  ').toMeta(), {
      'appVersion': '1.0.0',
    });
    expect(const DeviceAppInfo().toMeta(), isNull);
  });
}
