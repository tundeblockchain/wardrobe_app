import 'item_acquired_at.dart';

/// PATCH encoding for optional clothing-item acquired date (WARDROBE-93).
///
/// Mirrors subcategory clear on WARDROBE-86/87 until Backend WARDROBE-92
/// lands its own SHA (override in the PR body if that SHA differs):
///
/// * field **omitted** → no change
/// * JSON `null` → **clears** stored `acquiredAt` (REMOVE)
/// * `YYYY-MM-DD` → set the calendar date
///
/// Create still soft-omits empty / null. Never sends a blank string.
enum ItemAcquiredAtPatchOp { omit, clear, set }

final class ItemAcquiredAtPatch {
  const ItemAcquiredAtPatch.omit()
    : op = ItemAcquiredAtPatchOp.omit,
      value = null;

  const ItemAcquiredAtPatch.clear()
    : op = ItemAcquiredAtPatchOp.clear,
      value = null;

  const ItemAcquiredAtPatch.set(DateTime this.value)
    : op = ItemAcquiredAtPatchOp.set;

  final ItemAcquiredAtPatchOp op;
  final DateTime? value;

  bool get isOmit => op == ItemAcquiredAtPatchOp.omit;

  bool get isClear => op == ItemAcquiredAtPatchOp.clear;

  bool get isSet => op == ItemAcquiredAtPatchOp.set;

  /// Compare the stored value to the edit-form value.
  factory ItemAcquiredAtPatch.fromEdit({
    required DateTime? original,
    required DateTime? edited,
  }) {
    final previous = ItemAcquiredAt.dateOnlyOrNull(original);
    final next = ItemAcquiredAt.dateOnlyOrNull(edited);
    if (previous == next) {
      return const ItemAcquiredAtPatch.omit();
    }
    if (next == null) {
      return const ItemAcquiredAtPatch.clear();
    }
    return ItemAcquiredAtPatch.set(next);
  }

  /// Entries to merge into a PATCH JSON body. Clear uses JSON `null`.
  Map<String, dynamic> toJson() {
    switch (op) {
      case ItemAcquiredAtPatchOp.omit:
        return const {};
      case ItemAcquiredAtPatchOp.clear:
        return {'acquiredAt': null};
      case ItemAcquiredAtPatchOp.set:
        return {'acquiredAt': ItemAcquiredAt.toWire(value)};
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemAcquiredAtPatch && op == other.op && value == other.value;
  }

  @override
  int get hashCode => Object.hash(op, value);

  @override
  String toString() =>
      'ItemAcquiredAtPatch.$op(${ItemAcquiredAt.toWire(value)})';
}
