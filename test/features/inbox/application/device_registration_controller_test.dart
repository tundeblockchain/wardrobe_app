import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/inbox/application/device_registration_controller.dart';
import 'package:wardrobe_app/features/inbox/domain/device_registration.dart';

import '../../../helpers/fake_device_repository.dart';
import '../../../helpers/inbox_test_overrides.dart';

void main() {
  late FakeDeviceRepository devices;
  late FakePushTokenSource push;
  late ProviderContainer container;

  setUp(() {
    devices = FakeDeviceRepository();
    push = FakePushTokenSource();
    container = ProviderContainer.test(
      overrides: inboxTestOverrides(devices: devices, push: push),
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('skips PUT /me/devices when Messaging has no token', () async {
    container.read(deviceRegistrationControllerProvider);
    await settle();

    expect(push.currentCalls, greaterThan(0));
    expect(devices.registerCalls, 0);
    expect(container.read(deviceRegistrationControllerProvider), isNull);
  });

  test('registers when a token is available', () async {
    push.token = const PushToken(
      token: 'fcm-token',
      platform: DevicePlatform.android,
    );
    container.dispose();
    container = ProviderContainer.test(
      overrides: inboxTestOverrides(devices: devices, push: push),
    );

    await container
        .read(deviceRegistrationControllerProvider.notifier)
        .registerIfAvailable();
    await settle();

    expect(devices.registerCalls, greaterThanOrEqualTo(1));
    expect(devices.lastToken, 'fcm-token');
    expect(
      container.read(deviceRegistrationControllerProvider)?.deviceId,
      'dev_test1234567890',
    );
  });

  test('soft-fails registration errors', () async {
    push.token = const PushToken(
      token: 'fcm-token',
      platform: DevicePlatform.ios,
    );
    devices.nextFailure = const ApiException(
      message: 'Invalid platform.',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );

    await container
        .read(deviceRegistrationControllerProvider.notifier)
        .registerIfAvailable();

    expect(container.read(deviceRegistrationControllerProvider), isNull);
  });
}
