/// Presentation-level validators for wardrobe forms.
abstract final class WardrobeValidators {
  static const maxNameLength = 100;

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter a wardrobe name.';
    }
    if (trimmed.length > maxNameLength) {
      return 'Name must be $maxNameLength characters or fewer.';
    }
    return null;
  }
}
