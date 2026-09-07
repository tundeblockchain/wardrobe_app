import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:wardrobe_app/features/items/application/item_processing_poll.dart';

/// Instant, non-blocking item-processing polls for most tests.
///
/// [timeout] defaults to zero so a PENDING / PROCESSING item does not leave a
/// live poll loop spinning after the test assertion.
List<Override> itemProcessingPollTestOverrides({
  Duration interval = Duration.zero,
  Duration timeout = Duration.zero,
}) {
  return [
    itemProcessingPollConfigProvider.overrideWithValue(
      ItemProcessingPollConfig(interval: interval, timeout: timeout),
    ),
    itemProcessingDelayProvider.overrideWithValue((_) async {}),
  ];
}

/// Manual poll clock so tests can advance PROCESSING → FAILED one tick at a time.
class ItemProcessingPollTicks {
  final List<Completer<void>> _pending = [];

  int get waiting => _pending.length;

  List<Override> overrides({
    Duration interval = Duration.zero,
    Duration timeout = const Duration(minutes: 1),
  }) {
    return [
      itemProcessingPollConfigProvider.overrideWithValue(
        ItemProcessingPollConfig(interval: interval, timeout: timeout),
      ),
      itemProcessingDelayProvider.overrideWithValue((_) {
        final completer = Completer<void>();
        _pending.add(completer);
        return completer.future;
      }),
    ];
  }

  Future<void> tickAll() async {
    final waiting = [..._pending];
    _pending.clear();
    for (final completer in waiting) {
      completer.complete();
    }
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }
}
