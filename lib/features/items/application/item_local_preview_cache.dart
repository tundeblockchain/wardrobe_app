import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-session bytes for a just-uploaded clothing photo.
///
/// Backend item payloads expose S3 object keys, not GET URLs, while status is
/// PENDING / PROCESSING. Cards use this cache so the user's original photo
/// stays visible until a network URL (processed or original) is available.
class ItemLocalPreviewCache extends Notifier<Map<String, Uint8List>> {
  @override
  Map<String, Uint8List> build() => const {};

  void store(String itemId, Uint8List bytes) {
    if (itemId.isEmpty || bytes.isEmpty) {
      return;
    }
    state = {...state, itemId: bytes};
  }

  Uint8List? peek(String itemId) => state[itemId];

  void evict(String itemId) {
    if (!state.containsKey(itemId)) {
      return;
    }
    final next = Map<String, Uint8List>.from(state)..remove(itemId);
    state = next;
  }
}

final itemLocalPreviewCacheProvider =
    NotifierProvider<ItemLocalPreviewCache, Map<String, Uint8List>>(
      ItemLocalPreviewCache.new,
    );
