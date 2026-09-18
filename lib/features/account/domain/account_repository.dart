import 'account_wipe_summary.dart';

/// Owner-only wipe APIs. Identity comes from the Firebase ID token only.
abstract interface class AccountRepository {
  /// `DELETE /me/content` — wipe wardrobes/items/outfits; keep the Firebase user.
  Future<AccountWipeSummary> clearContent();

  /// `DELETE /me` — locked AccountDeleteResult (wardrobe-backend#49 `3f9b38a`).
  /// No body. Firebase Auth delete stays client-side after a successful wipe.
  Future<AccountWipeSummary> deleteAccount();
}
