import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';

/// In-session bytes for a just-uploaded clothing photo.
///
/// Backend item payloads may expose S3 object keys instead of GET URLs while
/// status is PENDING / PROCESSING / FAILED. Cards use this cache so the
/// original photo stays visible until a network URL is available.
class ItemLocalPreviewCache extends Notifier<Map<String, Uint8List>> {
  @override
  Map<String, Uint8List> build() {
    ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
    return const {};
  }

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

  /// Drops every preview so the next account cannot see prior upload bytes.
  void clear() {
    if (state.isEmpty) {
      return;
    }
    state = const {};
  }
}

final itemLocalPreviewCacheProvider =
    NotifierProvider<ItemLocalPreviewCache, Map<String, Uint8List>>(
      ItemLocalPreviewCache.new,
    );
