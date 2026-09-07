import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';
import '../data/in_app_reviewer.dart';
import '../domain/app_reviewer.dart';
import 'rate_app_state.dart';

/// Prompts for an in-app review, falling back to the platform store listing.
class RateAppController extends Notifier<RateAppState> {
  @override
  RateAppState build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const RateAppState();
  }

  AppReviewer get _reviewer => ref.read(appReviewerProvider);

  Future<void> rate() async {
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      await _reviewer.requestReview();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isBusy: false);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to open the store right now.',
      );
    }
  }
}

final rateAppControllerProvider =
    NotifierProvider<RateAppController, RateAppState>(RateAppController.new);
