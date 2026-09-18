import '../../entitlements/domain/subscription_tier.dart';
import 'account_delete_wire.dart';

/// `NONE` | `CANCELED` | `CANCEL_AT_PERIOD_END` | `CANCEL_FAILED`.
///
/// Locked WARDROBE-103 (wardrobe-backend#49 `3f9b38a`). Missing / unknown
/// → [unknown] so a legacy wipe body is a no-op follow-up.
enum SubscriptionCancelStatus {
  none(AccountDeleteWire.statusNone),
  canceled(AccountDeleteWire.statusCanceled),
  cancelAtPeriodEnd(AccountDeleteWire.statusCancelAtPeriodEnd),
  cancelFailed(AccountDeleteWire.statusCancelFailed),
  unknown('');

  const SubscriptionCancelStatus(this.wireValue);

  final String wireValue;

  static SubscriptionCancelStatus parse(String? value) {
    if (value == null || value.isEmpty) {
      return SubscriptionCancelStatus.unknown;
    }
    final normalized = value.trim().toUpperCase();
    for (final status in SubscriptionCancelStatus.values) {
      if (status == SubscriptionCancelStatus.unknown) {
        continue;
      }
      if (status.wireValue == normalized) {
        return status;
      }
    }
    return SubscriptionCancelStatus.unknown;
  }

  bool get isResolvedSuccess =>
      this == SubscriptionCancelStatus.none ||
      this == SubscriptionCancelStatus.canceled;

  bool get isFailed => this == SubscriptionCancelStatus.cancelFailed;

  bool get isPeriodEnd => this == SubscriptionCancelStatus.cancelAtPeriodEnd;
}

/// `IMMEDIATE` | `PERIOD_END`. Soft-omitted when unset.
enum SubscriptionCancelMode {
  immediate(AccountDeleteWire.cancelModeImmediate),
  periodEnd(AccountDeleteWire.cancelModePeriodEnd);

  const SubscriptionCancelMode(this.wireValue);

  final String wireValue;

  static SubscriptionCancelMode? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final normalized = value.trim().toUpperCase();
    for (final mode in SubscriptionCancelMode.values) {
      if (mode.wireValue == normalized) {
        return mode;
      }
    }
    return null;
  }
}

/// Optional `subscription` object on `DELETE /me` (WARDROBE-103).
class SubscriptionCancelInfo {
  const SubscriptionCancelInfo({
    this.status = SubscriptionCancelStatus.unknown,
    this.cancelMode,
    this.store,
    this.expiresAt,
    this.retryInStore = false,
  });

  static const absent = SubscriptionCancelInfo();

  final SubscriptionCancelStatus status;
  final SubscriptionCancelMode? cancelMode;
  final EntitlementStore? store;
  final DateTime? expiresAt;
  final bool retryInStore;

  bool get isFailed => status.isFailed;

  bool get isPeriodEnd => status.isPeriodEnd;

  bool get isResolvedSuccess => status.isResolvedSuccess;

  bool get shouldManageInStore => retryInStore || isFailed || isPeriodEnd;

  factory SubscriptionCancelInfo.fromDeleteJson(Map<String, dynamic> json) {
    final nested = _asMap(json[AccountDeleteWire.subscription]);
    if (nested == null) {
      return SubscriptionCancelInfo.absent;
    }
    return SubscriptionCancelInfo(
      status: SubscriptionCancelStatus.parse(
        _asString(nested[AccountDeleteWire.status]),
      ),
      cancelMode: SubscriptionCancelMode.tryParse(
        _asString(nested[AccountDeleteWire.cancelMode]),
      ),
      store: EntitlementStore.tryParse(
        _asString(nested[AccountDeleteWire.store]),
      ),
      expiresAt: _asDate(nested[AccountDeleteWire.expiresAt]),
      retryInStore: nested[AccountDeleteWire.retryInStore] == true,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SubscriptionCancelInfo &&
            status == other.status &&
            cancelMode == other.cancelMode &&
            store == other.store &&
            expiresAt == other.expiresAt &&
            retryInStore == other.retryInStore;
  }

  @override
  int get hashCode =>
      Object.hash(status, cancelMode, store, expiresAt, retryInStore);
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

String? _asString(Object? value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}

DateTime? _asDate(Object? value) {
  if (value is DateTime) {
    return value;
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
