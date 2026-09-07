import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

/// Controlled clothing categories from the backend contract.
///
/// Wire values stay on [wireValue]; UI uses [label].
enum ItemCategory {
  top('TOP', 'Top'),
  bottom('BOTTOM', 'Bottom'),
  dress('DRESS', 'Dress'),
  outerwear('OUTERWEAR', 'Outerwear'),
  shoes('SHOES', 'Shoes'),
  accessory('ACCESSORY', 'Accessory'),
  bag('BAG', 'Bag');

  const ItemCategory(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static ItemCategory? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final category in ItemCategory.values) {
      if (category.wireValue == value) {
        return category;
      }
    }
    return null;
  }
}

/// Clothing-item processing states from the SQS worker (WARDROBE-16/17/59).
///
/// Terminal failure on the wire is exactly `FAILED` (never `ERROR`). Poll
/// create / list / get until [ready] or [failed].
enum ItemProcessingStatus {
  pending('PENDING', 'Pending'),
  processing('PROCESSING', 'Processing'),
  ready('READY', 'Ready'),
  failed('FAILED', 'Failed'),
  unknown('UNKNOWN', 'Unknown');

  const ItemProcessingStatus(this.wireValue, this.label);

  final String wireValue;
  final String label;

  /// Still waiting on the worker. Keep polling.
  bool get isInProgress =>
      this == ItemProcessingStatus.pending ||
      this == ItemProcessingStatus.processing;

  /// Stop polling. [failed] is terminal and must not be treated as processing.
  bool get isTerminal =>
      this == ItemProcessingStatus.ready || this == ItemProcessingStatus.failed;

  static ItemProcessingStatus parse(String? value) {
    if (value == null || value.isEmpty) {
      return ItemProcessingStatus.ready;
    }
    for (final status in ItemProcessingStatus.values) {
      if (status.wireValue == value) {
        return status;
      }
    }
    return ItemProcessingStatus.unknown;
  }
}

/// Optional AI metadata from Phase-2 processing. User fields stay authoritative.
@freezed
abstract class ItemAiMetadata with _$ItemAiMetadata {
  const factory ItemAiMetadata({
    ItemCategory? detectedCategory,
    String? detectedSubcategory,
    @Default([]) List<String> detectedColours,
    bool? backgroundRemoved,
  }) = _ItemAiMetadata;
}

/// Clothing item as used by controllers and UI. Backend `itemId` is [id].
@freezed
abstract class Item with _$Item {
  const factory Item({
    required String id,
    required String wardrobeId,
    required String name,
    required ItemCategory category,
    String? subcategory,
    @Default([]) List<String> colours,
    String? brand,
    String? originalImageKey,
    String? processedImageKey,
    @Default(ItemProcessingStatus.ready) ItemProcessingStatus processingStatus,
    String? processingError,
    ItemAiMetadata? ai,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Item;
}
