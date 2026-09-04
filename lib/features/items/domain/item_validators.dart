import 'item.dart';

/// Presentation-level validators for item forms.
abstract final class ItemValidators {
  static const maxNameLength = 100;
  static const maxBrandLength = 100;
  static const maxSubcategoryLength = 64;

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter an item name.';
    }
    if (trimmed.length > maxNameLength) {
      return 'Name must be $maxNameLength characters or fewer.';
    }
    return null;
  }

  static String? category(ItemCategory? value) {
    if (value == null) {
      return 'Choose a category.';
    }
    return null;
  }

  static String? brand(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > maxBrandLength) {
      return 'Brand must be $maxBrandLength characters or fewer.';
    }
    return null;
  }

  static String? subcategory(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > maxSubcategoryLength) {
      return 'Subcategory must be $maxSubcategoryLength characters or fewer.';
    }
    return null;
  }

  /// Splits a comma-separated colour field into trimmed, non-empty tokens.
  static List<String> parseColours(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const [];
    }
    return [
      for (final part in value.split(','))
        if (part.trim().isNotEmpty) part.trim(),
    ];
  }
}
