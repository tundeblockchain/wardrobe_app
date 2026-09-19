import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/application/item_processing_poll.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  test('returns immediately when the seed is already terminal', () async {
    var fetches = 0;
    final ready = testItem();
    final result = await pollItemProcessing(
      fetch: () async {
        fetches++;
        return ready;
      },
      config: const ItemProcessingPollConfig(timeout: Duration.zero),
      delay: (_) async {},
      isMounted: () => true,
      onUpdate: (_) {},
      initial: ready,
    );

    expect(result?.processingStatus, ItemProcessingStatus.ready);
    expect(fetches, 0);
  });

  test('timeout stops polling without another fetch', () async {
    var fetches = 0;
    final pending = testItem(processingStatus: ItemProcessingStatus.pending);
    final result = await pollItemProcessing(
      fetch: () async {
        fetches++;
        return pending;
      },
      config: const ItemProcessingPollConfig(timeout: Duration.zero),
      delay: (_) async {},
      isMounted: () => true,
      onUpdate: (_) {},
      initial: pending,
    );

    expect(result?.processingStatus, ItemProcessingStatus.pending);
    expect(fetches, 0);
  });

  test('polls until READY when the clock advances', () async {
    final ticks = ItemProcessingPollTicks();
    final pending = testItem(processingStatus: ItemProcessingStatus.pending);
    final ready = pending.copyWith(
      processingStatus: ItemProcessingStatus.ready,
    );
    var fetches = 0;
    Item current = pending;

    final future = pollItemProcessing(
      fetch: () async {
        fetches++;
        return current;
      },
      config: const ItemProcessingPollConfig(
        interval: Duration.zero,
        timeout: Duration(minutes: 1),
      ),
      delay: ticks.wait,
      isMounted: () => true,
      onUpdate: (_) {},
      initial: pending,
    );

    await Future<void>.delayed(Duration.zero);
    expect(ticks.waiting, 1);
    current = ready;
    await ticks.tickAll();
    final result = await future;
    expect(result?.processingStatus, ItemProcessingStatus.ready);
    expect(fetches, 1);
  });
}
