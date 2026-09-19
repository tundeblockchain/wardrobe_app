import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/item.dart';

/// Interval and overall deadline for clothing-item processing polls.
///
/// WARDROBE-59: list/get until `processingStatus` is `READY` or `FAILED`.
/// WARDROBE-124 starts a poll after reprocess `202` / `409 PROCESSING_IN_PROGRESS`.
/// Timeout only stops polling — it never calls reprocess again.
class ItemProcessingPollConfig {
  const ItemProcessingPollConfig({
    this.interval = const Duration(seconds: 2),
    this.timeout = const Duration(minutes: 3),
  });

  final Duration interval;
  final Duration timeout;
}

typedef ItemProcessingDelay = Future<void> Function(Duration duration);

final itemProcessingPollConfigProvider = Provider<ItemProcessingPollConfig>((
  ref,
) {
  return const ItemProcessingPollConfig();
});

final itemProcessingDelayProvider = Provider<ItemProcessingDelay>((ref) {
  return Future<void>.delayed;
});

/// Poll [fetch] until READY / FAILED. Does not enqueue or invent a retry.
Future<Item?> pollItemProcessing({
  required Future<Item> Function() fetch,
  required ItemProcessingPollConfig config,
  required ItemProcessingDelay delay,
  required bool Function() isMounted,
  required void Function(Item item) onUpdate,
  Item? initial,
}) async {
  var current = initial;
  final deadline = DateTime.now().add(config.timeout);
  while (isMounted()) {
    if (current != null && current.processingStatus.isTerminal) {
      return current;
    }
    if (!DateTime.now().isBefore(deadline)) {
      return current;
    }
    await delay(config.interval);
    if (!isMounted()) {
      return current;
    }
    current = await fetch();
    if (!isMounted()) {
      return current;
    }
    onUpdate(current);
  }
  return current;
}
