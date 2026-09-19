import '../../../core/network/api_exception.dart';
import '../../entitlements/domain/entitlement_error_codes.dart';
import '../../entitlements/domain/paywall_placement.dart';
import 'item.dart';

/// Move relocates the same item; copy creates a new `itemId`.
enum ItemTransferKind {
  move,
  copy;

  String get verb => this == ItemTransferKind.move ? 'Move' : 'Copy';

  String get verbLower => this == ItemTransferKind.move ? 'move' : 'copy';

  String get gerund => this == ItemTransferKind.move ? 'Moving' : 'Copying';

  bool get countsTowardItemLimit => this == ItemTransferKind.copy;
}

/// User-facing copy for move/copy (WARDROBE-119).
abstract final class ItemTransferMessages {
  static const processing =
      'This item is still processing. Wait until it is ready or failed, '
      'then try again.';

  static const sameWardrobe = 'Choose a different wardrobe.';

  static const wardrobeNotFound = 'That wardrobe was not found.';

  static const itemNotFound = 'That item was not found.';

  static const noDestinations =
      'Create another wardrobe to move or copy items.';

  static const outfitBlock =
      'This item is used in an outfit. Remove it from outfits in this '
      'wardrobe first.';

  static const itemLimitUpgrade =
      'Free includes 5 items. Upgrade to copy this item into another wardrobe.';

  static const unauthenticated = 'Sign in again to move or copy this item.';

  static String failed(ItemTransferKind kind) =>
      'Could not ${kind.verbLower} this item. Please try again.';

  static String confirmTitle(ItemTransferKind kind) =>
      '${kind.verb} this item?';

  static String confirmMessage(ItemTransferKind kind, String wardrobeName) =>
      '${kind.verb} this item to $wardrobeName?';

  static String success(ItemTransferKind kind, String wardrobeName) =>
      kind == ItemTransferKind.move
      ? 'Moved to $wardrobeName.'
      : 'Copied to $wardrobeName.';

  static String outfitBlockWithId(String outfitId) =>
      'This item is used in an outfit ($outfitId). Remove it from that '
      'outfit first.';

  static String pickerTitle(ItemTransferKind kind) =>
      '${kind.verb} to another wardrobe';
}

/// Outfit ids from Backend WARDROBE-118 (`outfit_{nanoid}`).
final _outfitIdPattern = RegExp(r'outfit_[A-Za-z0-9_-]+');

/// Pulls the first `outfit_*` token from a Backend 400 message.
String? extractOutfitId(String message) {
  return _outfitIdPattern.firstMatch(message)?.group(0);
}

/// Maps Backend 400/403/404 envelopes to clear item-transfer copy.
String mapItemTransferError(
  ApiException error, {
  required ItemTransferKind kind,
}) {
  final code = error.code?.trim().toUpperCase();
  final message = error.message.trim();
  final lower = message.toLowerCase();

  if (code == EntitlementErrorCodes.itemLimit ||
      (EntitlementErrorCodes.isEntitlementStatus(error.statusCode) &&
          (EntitlementErrorCodes.isEntitlementCode(code) ||
              code == null ||
              code.isEmpty))) {
    return ItemTransferMessages.itemLimitUpgrade;
  }

  if (code == 'WARDROBE_NOT_FOUND') {
    return ItemTransferMessages.wardrobeNotFound;
  }
  if (code == 'ITEM_NOT_FOUND') {
    return ItemTransferMessages.itemNotFound;
  }
  if (code == 'UNAUTHENTICATED' || error.statusCode == 401) {
    return ItemTransferMessages.unauthenticated;
  }

  if (code == 'VALIDATION_ERROR' || error.statusCode == 400) {
    if (lower.contains('processing') ||
        lower.contains('pending') ||
        lower.contains('ready or failed')) {
      return ItemTransferMessages.processing;
    }
    if (lower.contains('outfit')) {
      final outfitId = extractOutfitId(message);
      if (outfitId != null) {
        return ItemTransferMessages.outfitBlockWithId(outfitId);
      }
      return ItemTransferMessages.outfitBlock;
    }
    if (lower.contains('different wardrobe') ||
        lower.contains('targetwardrobeid') ||
        lower.contains('same')) {
      return ItemTransferMessages.sameWardrobe;
    }
    if (message.isNotEmpty) {
      return message;
    }
  }

  if (message.isNotEmpty) {
    return message;
  }
  return ItemTransferMessages.failed(kind);
}

/// Soft-fail upgrade CTA when WARDROBE-117 paywall UX is not merged.
PaywallPlacement? itemTransferPaywallPlacement(ApiException error) {
  return PaywallPlacement.fromApiException(
    error,
    fallback: PaywallPlacement.itemLimit,
  );
}

/// Destinations exclude the source wardrobe (WARDROBE-118).
List<T> destinationsExcluding<T>(
  Iterable<T> items,
  bool Function(T item) isSource,
) {
  return [
    for (final item in items)
      if (!isSource(item)) item,
  ];
}

/// Move/copy only after the processing worker is done (`READY` / `FAILED`).
bool canTransferItem(Item item) => item.processingStatus.isTerminal;
