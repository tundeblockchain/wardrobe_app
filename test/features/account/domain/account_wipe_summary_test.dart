import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/account/domain/account_wipe_summary.dart';
import 'package:wardrobe_app/features/account/domain/subscription_cancel_info.dart';

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

  test('fromJson soft-omits WARDROBE-103 subscription fields', () {
    final summary = AccountWipeSummary.fromJson(const {
      'keepAccount': false,
      'deletedWardrobes': 0,
      'deletedItems': 0,
      'deletedOutfits': 0,
      'deletedS3Objects': 0,
      's3Failures': 0,
    });

    expect(summary.deleted, isNull);
    expect(summary.entitlementRevoked, isNull);
    expect(summary.subscription, SubscriptionCancelInfo.absent);
    expect(summary.isAccountDeleted, isTrue);
  });

  test('fromJson maps deleted, entitlementRevoked, and CANCEL_FAILED', () {
    final summary = AccountWipeSummary.fromJson(const {
      'keepAccount': false,
      'deleted': true,
      'entitlementRevoked': true,
      'subscription': {
        'status': 'CANCEL_FAILED',
        'retryInStore': true,
        'code': 'SUBSCRIPTION_CANCEL_FAILED',
      },
    });

    expect(summary.deleted, isTrue);
    expect(summary.entitlementRevoked, isTrue);
    expect(summary.isAccountDeleted, isTrue);
    expect(summary.subscription.isFailed, isTrue);
    expect(summary.subscription.retryInStore, isTrue);
  });

  test('isAccountDeleted is false when deleted is explicitly false', () {
    final summary = AccountWipeSummary.fromJson(const {
      'keepAccount': false,
      'deleted': false,
    });
    expect(summary.isAccountDeleted, isFalse);
  });
}
