import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/account/domain/account_wipe_summary.dart';

void main() {
  test('fromJson maps the WARDROBE-36 summary shape', () {
    final summary = AccountWipeSummary.fromJson(const {
      'keepAccount': true,
      'deletedWardrobes': 1,
      'deletedItems': 2,
      'deletedOutfits': 1,
      'deletedS3Objects': 3,
      's3Failures': 0,
    });

    expect(summary.keepAccount, isTrue);
    expect(summary.deletedWardrobes, 1);
    expect(summary.deletedItems, 2);
    expect(summary.deletedOutfits, 1);
    expect(summary.deletedAiProfiles, 0);
    expect(summary.deletedS3Objects, 3);
    expect(summary.s3Failures, 0);
    expect(summary.hadS3Failures, isFalse);
  });

  test('fromJson treats an empty account as zeros', () {
    final summary = AccountWipeSummary.fromJson(const {'keepAccount': false});

    expect(summary.keepAccount, isFalse);
    expect(summary.deletedWardrobes, 0);
    expect(summary.deletedItems, 0);
    expect(summary.deletedOutfits, 0);
    expect(summary.deletedS3Objects, 0);
    expect(summary.s3Failures, 0);
  });

  test('fromJson maps deletedAiProfiles when present', () {
    final summary = AccountWipeSummary.fromJson(const {
      'keepAccount': true,
      'deletedWardrobes': 0,
      'deletedItems': 0,
      'deletedOutfits': 0,
      'deletedAiProfiles': 1,
      'deletedS3Objects': 2,
      's3Failures': 0,
    });

    expect(summary.deletedAiProfiles, 1);
    expect(summary.feedbackMessage, contains('1 AI profile'));
  });

  test('feedbackMessage mentions S3 failures', () {
    const summary = AccountWipeSummary(
      keepAccount: true,
      deletedWardrobes: 0,
      deletedItems: 0,
      deletedOutfits: 0,
      deletedS3Objects: 0,
      s3Failures: 2,
    );

    expect(summary.hadS3Failures, isTrue);
    expect(
      summary.feedbackMessage,
      contains('Some photos could not be removed'),
    );
  });
}
