import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../ai_profiles/application/generic_models_controller.dart';
import '../../ai_profiles/application/personal_ai_profiles_controller.dart';
import '../../ai_profiles/application/selected_ai_profile.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/auth_failure.dart';
import '../../items/application/items_controller.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../recommendations/application/recommendations_controller.dart';
import '../../wardrobes/application/wardrobe_detail_controller.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../data/dio_account_repository.dart';
import '../domain/account_repository.dart';
import '../domain/account_wipe_summary.dart';
import 'account_state.dart';

/// Clear-all content and delete-account actions against `/me`.
class AccountController extends Notifier<AccountState> {
  @override
  AccountState build() => const AccountState();

  AccountRepository get _repository => ref.read(accountRepositoryProvider);

  /// Wipes wardrobes/items/outfits. Firebase session stays signed in.
  Future<AccountWipeSummary?> clearContent() async {
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    try {
      final summary = await _repository.clearContent();
      await _refreshLocalLists();
      if (!ref.mounted) {
        return summary;
      }
      state = state.copyWith(
        isBusy: false,
        lastSummary: summary,
        infoMessage: summary.feedbackMessage,
      );
      return summary;
    } on ApiException catch (error) {
      return _fail(error.message);
    } catch (_) {
      return _fail('Something went wrong. Please try again.');
    }
  }

  /// Wipes AWS data, then deletes the Firebase Auth user client-side.
  ///
  /// Failures after a successful `DELETE /me` are surfaced — never treated as
  /// a completed account deletion.
  Future<AccountWipeSummary?> deleteAccount() async {
    state = state.copyWith(isBusy: true, clearError: true, clearInfo: true);
    try {
      final summary = await _repository.deleteAccount();
      try {
        await ref.read(authRepositoryProvider).deleteUser();
      } on AuthFailure catch (failure) {
        if (!ref.mounted) {
          return null;
        }
        state = state.copyWith(
          isBusy: false,
          lastSummary: summary,
          errorMessage: _firebaseDeleteFailedMessage(failure),
        );
        return null;
      } catch (_) {
        if (!ref.mounted) {
          return null;
        }
        state = state.copyWith(
          isBusy: false,
          lastSummary: summary,
          errorMessage: _firebaseDeleteFailedMessage(null),
        );
        return null;
      }
      if (!ref.mounted) {
        return summary;
      }
      state = state.copyWith(
        isBusy: false,
        isAccountDeleted: true,
        lastSummary: summary,
      );
      return summary;
    } on ApiException catch (error) {
      return _fail(error.message);
    } catch (_) {
      return _fail('Something went wrong. Please try again.');
    }
  }

  Future<void> _refreshLocalLists() async {
    ref.read(wardrobesControllerProvider.notifier).clearLocal();
    ref.invalidate(personalAiProfilesControllerProvider);
    ref.invalidate(genericModelsControllerProvider);
    ref.invalidate(selectedAiProfileProvider);
    ref.invalidate(wardrobeDetailControllerProvider);
    ref.invalidate(itemsControllerProvider);
    ref.invalidate(outfitsControllerProvider);
    ref.invalidate(recommendationsControllerProvider);
    await ref.read(wardrobesControllerProvider.notifier).refresh();
  }

  AccountWipeSummary? _fail(String message) {
    if (!ref.mounted) {
      return null;
    }
    state = state.copyWith(isBusy: false, errorMessage: message);
    return null;
  }

  String _firebaseDeleteFailedMessage(AuthFailure? failure) {
    final detail = failure?.message;
    if (detail != null && detail.isNotEmpty) {
      return 'Your wardrobe data was deleted, but the sign-in account '
          'could not be removed. $detail';
    }
    return 'Your wardrobe data was deleted, but the sign-in account '
        'could not be removed. Sign in again and retry Delete account.';
  }
}

final accountControllerProvider =
    NotifierProvider<AccountController, AccountState>(AccountController.new);
