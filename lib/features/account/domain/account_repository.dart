import 'account_wipe_summary.dart';

/// Owner-only wipe APIs. Identity comes from the Firebase ID token only.
abstract interface class AccountRepository {
  /// `DELETE /me/content` — wipe wardrobes/items/outfits; keep the Firebase user.
  Future<AccountWipeSummary> clearContent();

  /// `DELETE /me` — same wipe (plus PROFILE). Firebase Auth delete is client-side.
  Future<AccountWipeSummary> deleteAccount();
}
