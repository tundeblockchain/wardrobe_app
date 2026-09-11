/// PATCH encoding for optional clothing-item subcategory (WARDROBE-86).
///
/// Matches Backend [WARDROBE-87](https://tundetunde000.atlassian.net/browse/WARDROBE-87)
/// on wardrobe-backend `2cb2285913aec9d66d6e34b447d289b5eb28b6f1`:
///
/// * field **omitted** → no change
/// * JSON `null` / blank / whitespace → **clears** stored subcategory (REMOVE)
/// * non-empty string → set the trimmed value (not limited to filter enums)
///
/// Never invents dummy tokens (`NONE`, `UNSET`, …). Create still soft-omits
/// empty subcategory.
enum ItemSubcategoryPatchOp { omit, clear, set }

final class ItemSubcategoryPatch {
  const ItemSubcategoryPatch.omit()
    : op = ItemSubcategoryPatchOp.omit,
      value = null;

  const ItemSubcategoryPatch.clear()
    : op = ItemSubcategoryPatchOp.clear,
      value = null;

  const ItemSubcategoryPatch.set(String this.value)
    : op = ItemSubcategoryPatchOp.set;

  final ItemSubcategoryPatchOp op;
  final String? value;

  bool get isOmit => op == ItemSubcategoryPatchOp.omit;

  bool get isClear => op == ItemSubcategoryPatchOp.clear;

  bool get isSet => op == ItemSubcategoryPatchOp.set;

  /// Trimmed token, or `null` when the user left subcategory empty/none.
  static String? normalize(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  /// Compare the stored value to the edit-form value.
  factory ItemSubcategoryPatch.fromEdit({
    required String? original,
    required String? edited,
  }) {
    final previous = normalize(original);
    final next = normalize(edited);
    if (previous == next) {
      return const ItemSubcategoryPatch.omit();
    }
    if (next == null) {
      return const ItemSubcategoryPatch.clear();
    }
    return ItemSubcategoryPatch.set(next);
  }

  /// Entries to merge into a PATCH JSON body. Clear uses JSON `null`.
  Map<String, dynamic> toJson() {
    switch (op) {
      case ItemSubcategoryPatchOp.omit:
        return const {};
      case ItemSubcategoryPatchOp.clear:
        return {'subcategory': null};
      case ItemSubcategoryPatchOp.set:
        return {'subcategory': value};
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ItemSubcategoryPatch && op == other.op && value == other.value;
  }

  @override
  int get hashCode => Object.hash(op, value);

  @override
  String toString() => 'ItemSubcategoryPatch.$op($value)';
}
