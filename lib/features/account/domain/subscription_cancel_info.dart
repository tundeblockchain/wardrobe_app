import 'account_delete_wire.dart';

/// Store-cancel outcome from `DELETE /me` (provisional WARDROBE-103).
enum SubscriptionCancelStatus {
  none(AccountDeleteWire.statusNone),
  canceled(AccountDeleteWire.statusCanceled),
  cancelAtPeriodEnd(AccountDeleteWire.statusCancelAtPeriodEnd),
  cancelFailed(AccountDeleteWire.statusCancelFailed),
  succeeded(AccountDeleteWire.statusSucceeded),
  skipped(AccountDeleteWire.statusSkipped),
  failed(AccountDeleteWire.statusFailed),
  unknown('');

  const SubscriptionCancelStatus(this.wireValue);

  final String wireValue;

  /// Unknown / missing → [unknown] so legacy `DELETE /me` stays a no-op.
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
      this == SubscriptionCancelStatus.canceled ||
      this == SubscriptionCancelStatus.succeeded ||
      this == SubscriptionCancelStatus.skipped;

  bool get isFailed =>
      this == SubscriptionCancelStatus.cancelFailed ||
      this == SubscriptionCancelStatus.failed;

  bool get isPeriodEnd => this == SubscriptionCancelStatus.cancelAtPeriodEnd;
}

/// Optional `subscription` / `subscriptionCancel` object on `DELETE /me`.
class SubscriptionCancelInfo {
  const SubscriptionCancelInfo({
    this.status = SubscriptionCancelStatus.unknown,
    this.cancelMode,
    this.store,
    this.expiresAt,
    this.retryInStore = false,
    this.code,
    this.message,
    this.failedFlag = false,
  });

  static const absent = SubscriptionCancelInfo();

  final SubscriptionCancelStatus status;
  final String? cancelMode;
  final String? store;
  final DateTime? expiresAt;
  final bool retryInStore;
  final String? code;
  final String? message;
  final bool failedFlag;

  bool get isFailed {
    if (status.isResolvedSuccess) {
      return false;
    }
    if (status.isFailed || failedFlag) {
      return true;
    }
    final code = this.code?.trim().toUpperCase();
    return code == AccountDeleteWire.subscriptionCancelFailedCode;
  }

  bool get isPeriodEnd => status.isPeriodEnd;

  bool get shouldManageInStore => retryInStore || isFailed || isPeriodEnd;

  factory SubscriptionCancelInfo.fromDeleteJson(Map<String, dynamic> json) {
    final primary = _asMap(json[AccountDeleteWire.subscription]);
    final alt = _asMap(json[AccountDeleteWire.subscriptionCancel]);
    final nested = <String, dynamic>{
      if (alt != null) ...alt,
      if (primary != null) ...primary,
    };
    final failedFlag = json[AccountDeleteWire.subscriptionCancelFailed] == true;
    final topCode = _asString(json[AccountDeleteWire.code]);
    final topMessage = _asString(json[AccountDeleteWire.message]);
    final nestedStatus = SubscriptionCancelStatus.parse(
      _asString(nested[AccountDeleteWire.status]),
    );
    final nestedCode =
        _asString(nested[AccountDeleteWire.code]) ??
        (failedFlag ? AccountDeleteWire.subscriptionCancelFailedCode : null) ??
        topCode;
    final status = nestedStatus != SubscriptionCancelStatus.unknown
        ? nestedStatus
        : (failedFlag ||
                  nestedCode?.toUpperCase() ==
                      AccountDeleteWire.subscriptionCancelFailedCode
              ? SubscriptionCancelStatus.cancelFailed
              : SubscriptionCancelStatus.unknown);

    if (nested.isEmpty &&
        !failedFlag &&
        nestedCode == null &&
        topMessage == null) {
      return SubscriptionCancelInfo.absent;
    }

    return SubscriptionCancelInfo(
      status: status,
      cancelMode: _asString(nested[AccountDeleteWire.cancelMode]),
      store: _asString(nested[AccountDeleteWire.store]),
      expiresAt: _asDate(nested[AccountDeleteWire.expiresAt]),
      retryInStore: nested[AccountDeleteWire.retryInStore] == true,
      code: nestedCode,
      message:
          _asString(nested[AccountDeleteWire.message]) ??
          topMessage ??
          (status.isFailed
              ? 'The store subscription could not be canceled.'
              : null),
      failedFlag: failedFlag,
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
            retryInStore == other.retryInStore &&
            code == other.code &&
            message == other.message &&
            failedFlag == other.failedFlag;
  }

  @override
  int get hashCode => Object.hash(
    status,
    cancelMode,
    store,
    expiresAt,
    retryInStore,
    code,
    message,
    failedFlag,
  );
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
