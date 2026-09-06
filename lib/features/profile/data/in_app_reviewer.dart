import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import '../domain/app_reviewer.dart';

/// Optional App Store id for `openStoreListing` on iOS.
const String kIosAppStoreIdDefine = String.fromEnvironment('IOS_APP_STORE_ID');

/// `in_app_review` implementation with a store-listing fallback.
class InAppReviewAppReviewer implements AppReviewer {
  InAppReviewAppReviewer({InAppReview? inAppReview, String? iosAppStoreId})
    : _inAppReview = inAppReview ?? InAppReview.instance,
      _iosAppStoreId = iosAppStoreId ?? kIosAppStoreIdDefine;

  final InAppReview _inAppReview;
  final String _iosAppStoreId;

  @override
  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      return;
    }
    await _inAppReview.openStoreListing(
      appStoreId: _iosAppStoreId.isEmpty ? null : _iosAppStoreId,
    );
  }
}

/// Default [AppReviewer]. Override in tests with a fake.
final appReviewerProvider = Provider<AppReviewer>((ref) {
  return InAppReviewAppReviewer();
});
