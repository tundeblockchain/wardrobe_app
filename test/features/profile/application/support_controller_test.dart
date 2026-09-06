import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/profile/application/support_controller.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';
import 'package:wardrobe_app/features/profile/data/package_info_device_context.dart';
import 'package:wardrobe_app/features/profile/domain/support_form_kind.dart';

import '../../../helpers/fake_device_context.dart';
import '../../../helpers/fake_support_repository.dart';

void main() {
  late FakeSupportRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeSupportRepository();
    container = ProviderContainer.test(
      overrides: [
        supportRepositoryProvider.overrideWithValue(repository),
        deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('contact submit posts trimmed fields plus device context', () async {
    container.read(supportControllerProvider(SupportFormKind.contact));
    await settle();

    final sent = await container
        .read(supportControllerProvider(SupportFormKind.contact).notifier)
        .submit(
          subject: '  Hello  ',
          message: '  Please help with my wardrobe.  ',
        );

    expect(sent, isTrue);
    expect(repository.contactCalls, 1);
    expect(repository.bugCalls, 0);
    expect(repository.lastRequest?.subject, 'Hello');
    expect(repository.lastRequest?.message, 'Please help with my wardrobe.');
    expect(repository.lastRequest?.device, 'Pixel 8 (Android 14)');
    expect(repository.lastRequest?.appVersion, '1.0.0+1');
    expect(
      container
          .read(supportControllerProvider(SupportFormKind.contact))
          .isSubmitting,
      isFalse,
    );
  });

  test('bug submit posts to the bug repository method', () async {
    container.read(supportControllerProvider(SupportFormKind.bug));
    await settle();

    final sent = await container
        .read(supportControllerProvider(SupportFormKind.bug).notifier)
        .submit(
          subject: 'Crash',
          message: 'The add-item screen froze after picking a photo.',
        );

    expect(sent, isTrue);
    expect(repository.bugCalls, 1);
    expect(repository.contactCalls, 0);
    expect(repository.lastRequest?.subject, 'Crash');
  });

  test('records a friendly error when support is not deployed yet', () async {
    repository.nextFailure = const ApiException(
      message: 'Not found.',
      code: 'NOT_FOUND',
      statusCode: 404,
    );
    container.read(supportControllerProvider(SupportFormKind.contact));
    await settle();

    final sent = await container
        .read(supportControllerProvider(SupportFormKind.contact).notifier)
        .submit(subject: 'Hello', message: 'Please help with my wardrobe.');

    expect(sent, isFalse);
    expect(
      container
          .read(supportControllerProvider(SupportFormKind.contact))
          .errorMessage,
      "Support isn't available yet. Please try again later.",
    );
  });

  test('surfaces other ApiException messages', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );
    container.read(supportControllerProvider(SupportFormKind.bug));
    await settle();

    final sent = await container
        .read(supportControllerProvider(SupportFormKind.bug).notifier)
        .submit(
          subject: 'Crash',
          message: 'The add-item screen froze after picking a photo.',
        );

    expect(sent, isFalse);
    expect(
      container
          .read(supportControllerProvider(SupportFormKind.bug))
          .errorMessage,
      contains('connection'),
    );
  });
}
