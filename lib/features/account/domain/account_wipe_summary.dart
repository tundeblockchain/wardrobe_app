import 'account_delete_wire.dart';
import 'subscription_cancel_info.dart';

/// Success body from `DELETE /me/content` and `DELETE /me` (WARDROBE-36).
///
/// Production `DELETE /me` is locked to wardrobe-backend#49 merge SHA
/// `3f9b38a`: `deleted`, `keepAccount`, `entitlementRevoked`, and
/// `subscription`. `DELETE /me/content` stays the content-wipe body without
/// those keys.
class AccountWipeSummary {
  const AccountWipeSummary({
    required this.keepAccount,
    required this.deletedWardrobes,
    required this.deletedItems,
    required this.deletedOutfits,
    this.deletedAiProfiles = 0,
    required this.deletedS3Objects,
    required this.s3Failures,
    this.deleted,
    this.entitlementRevoked,
    this.subscription = SubscriptionCancelInfo.absent,
  });

  final bool keepAccount;
  final int deletedWardrobes;
  final int deletedItems;
  final int deletedOutfits;
  final int deletedAiProfiles;
  final int deletedS3Objects;
  final int s3Failures;

  /// WARDROBE-103: Firebase Auth delete when `true`. Null on `/me/content`.
  final bool? deleted;

  /// Server-side entitlement revoke result. Null on `/me/content`.
  final bool? entitlementRevoked;

  /// Store cancel outcome. Absent on `DELETE /me/content`.
  final SubscriptionCancelInfo subscription;

  /// Locked AccountDeleteResult (`3f9b38a`) — required on `DELETE /me`.
  static bool hasLockedDeleteEnvelope(Map<String, dynamic> json) {
    if (json[AccountDeleteWire.deleted] != true) {
      return false;
    }
    if (json[AccountDeleteWire.keepAccount] != false) {
      return false;
    }
    if (json[AccountDeleteWire.entitlementRevoked] != true) {
      return false;
    }
    final nested = json[AccountDeleteWire.subscription];
    if (nested is! Map) {
      return false;
    }
    final status = nested[AccountDeleteWire.status];
    return SubscriptionCancelStatus.parse(status is String ? status : null) !=
        SubscriptionCancelStatus.unknown;
  }

  bool get hadS3Failures => s3Failures > 0;

  /// Account record is gone — proceed to Firebase Auth delete.
  bool get isAccountDeleted {
    if (deleted == true) {
      return true;
    }
    if (deleted == false) {
      return false;
    }
    return !keepAccount;
  }

  factory AccountWipeSummary.fromJson(Map<String, dynamic> json) {
    return AccountWipeSummary(
      keepAccount: json['keepAccount'] == true,
      deletedWardrobes: _asInt(json['deletedWardrobes']),
      deletedItems: _asInt(json['deletedItems']),
      deletedOutfits: _asInt(json['deletedOutfits']),
      deletedAiProfiles: _asInt(json['deletedAiProfiles']),
      deletedS3Objects: _asInt(json['deletedS3Objects']),
      s3Failures: _asInt(json['s3Failures']),
      deleted: _asOptionalBool(json[AccountDeleteWire.deleted]),
      entitlementRevoked: _asOptionalBool(
        json[AccountDeleteWire.entitlementRevoked],
      ),
      subscription: SubscriptionCancelInfo.fromDeleteJson(json),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  static bool? _asOptionalBool(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    return null;
  }

  String get feedbackMessage {
    final parts = <String>[
      if (deletedWardrobes == 1)
        '1 wardrobe'
      else
        '$deletedWardrobes wardrobes',
      if (deletedItems == 1) '1 item' else '$deletedItems items',
      if (deletedOutfits == 1) '1 outfit' else '$deletedOutfits outfits',
      if (deletedAiProfiles == 1)
        '1 AI profile'
      else if (deletedAiProfiles > 0)
        '$deletedAiProfiles AI profiles',
    ];
    final summary = 'Removed ${parts.join(', ')}.';
    if (hadS3Failures) {
      return '$summary Some photos could not be removed from storage.';
    }
    return summary;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AccountWipeSummary &&
            keepAccount == other.keepAccount &&
            deletedWardrobes == other.deletedWardrobes &&
            deletedItems == other.deletedItems &&
            deletedOutfits == other.deletedOutfits &&
            deletedAiProfiles == other.deletedAiProfiles &&
            deletedS3Objects == other.deletedS3Objects &&
            s3Failures == other.s3Failures &&
            deleted == other.deleted &&
            entitlementRevoked == other.entitlementRevoked &&
            subscription == other.subscription;
  }

  @override
  int get hashCode => Object.hash(
    keepAccount,
    deletedWardrobes,
    deletedItems,
    deletedOutfits,
    deletedAiProfiles,
    deletedS3Objects,
    s3Failures,
    deleted,
    entitlementRevoked,
    subscription,
  );
}
