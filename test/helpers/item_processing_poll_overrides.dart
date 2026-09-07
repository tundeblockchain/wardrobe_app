import 'package:flutter_riverpod/misc.dart';
import 'package:wardrobe_app/features/items/application/item_processing_poll.dart';

/// Instant item-processing polls so widget/unit tests do not wait on timers.
List<Override> itemProcessingPollTestOverrides({
  Duration interval = Duration.zero,
  Duration timeout = const Duration(minutes: 1),
}) {
  return [
    itemProcessingPollConfigProvider.overrideWithValue(
      ItemProcessingPollConfig(interval: interval, timeout: timeout),
    ),
    itemProcessingDelayProvider.overrideWithValue((_) async {}),
  ];
}
