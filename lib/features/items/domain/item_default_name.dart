import 'item_validators.dart';
import 'picked_image.dart';

/// Fallback name for a gallery photo when the user does not type one.
String defaultItemName(PickedImage image, int index) {
  final raw = image.fileName?.trim() ?? '';
  if (raw.isNotEmpty) {
    final dot = raw.lastIndexOf('.');
    final base = dot > 0 ? raw.substring(0, dot) : raw;
    final cleaned = base.replaceAll(RegExp(r'[_\-]+'), ' ').trim();
    if (cleaned.isNotEmpty) {
      if (cleaned.length > ItemValidators.maxNameLength) {
        return cleaned.substring(0, ItemValidators.maxNameLength);
      }
      return cleaned;
    }
  }
  return 'New item ${index + 1}';
}
