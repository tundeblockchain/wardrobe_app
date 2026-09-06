import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/profile/application/rate_app_controller.dart';
import 'package:wardrobe_app/features/profile/data/in_app_reviewer.dart';

import '../../../helpers/fake_app_reviewer.dart';

void main() {
  late FakeAppReviewer reviewer;
  late ProviderContainer container;

  setUp(() {
    reviewer = FakeAppReviewer();
    container = ProviderContainer.test(
      overrides: [appReviewerProvider.overrideWithValue(reviewer)],
    );
  });

  tearDown(() => container.dispose());

  test('rate delegates to AppReviewer', () async {
    await container.read(rateAppControllerProvider.notifier).rate();

    expect(reviewer.requestCalls, 1);
    expect(container.read(rateAppControllerProvider).isBusy, isFalse);
    expect(container.read(rateAppControllerProvider).errorMessage, isNull);
  });

  test('rate records a friendly error when the store is unavailable', () async {
    reviewer.nextError = Exception('plugin missing');

    await container.read(rateAppControllerProvider.notifier).rate();

    expect(reviewer.requestCalls, 1);
    expect(
      container.read(rateAppControllerProvider).errorMessage,
      'Unable to open the store right now.',
    );
    expect(container.read(rateAppControllerProvider).isBusy, isFalse);
  });
}
