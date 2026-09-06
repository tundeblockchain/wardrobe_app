import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wardrobe_app/features/profile/data/in_app_reviewer.dart';

class MockInAppReview extends Mock implements InAppReview {}

void main() {
  late MockInAppReview review;
  late InAppReviewAppReviewer reviewer;

  setUp(() {
    review = MockInAppReview();
    reviewer = InAppReviewAppReviewer(
      inAppReview: review,
      iosAppStoreId: '1234567890',
    );
  });

  test('requests an in-app review when the plugin is available', () async {
    when(() => review.isAvailable()).thenAnswer((_) async => true);
    when(() => review.requestReview()).thenAnswer((_) async {});

    await reviewer.requestReview();

    verify(() => review.requestReview()).called(1);
    verifyNever(
      () => review.openStoreListing(
        appStoreId: any(named: 'appStoreId'),
        microsoftStoreId: any(named: 'microsoftStoreId'),
      ),
    );
  });

  test('opens the store listing when in-app review is unavailable', () async {
    when(() => review.isAvailable()).thenAnswer((_) async => false);
    when(
      () => review.openStoreListing(
        appStoreId: any(named: 'appStoreId'),
        microsoftStoreId: any(named: 'microsoftStoreId'),
      ),
    ).thenAnswer((_) async {});

    await reviewer.requestReview();

    verify(
      () => review.openStoreListing(
        appStoreId: '1234567890',
        microsoftStoreId: any(named: 'microsoftStoreId'),
      ),
    ).called(1);
    verifyNever(() => review.requestReview());
  });
}
