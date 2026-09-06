import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobe_cover_provider.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  late FakeItemRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeItemRepository();
    container = ProviderContainer.test(
      overrides: [itemRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('loads the first item from the existing list-items API', () async {
    repository.items.addAll([
      testItem(),
      testItem(id: 'item_jeans', name: 'Blue jeans'),
    ]);

    final cover = await container.read(
      wardrobeCoverProvider('wd_abc123').future,
    );

    expect(cover.firstItem?.id, 'item_xyz123');
    expect(cover.itemCount, 2);
    expect(repository.listCalls, 1);
    expect(repository.lastListFilters.isEmpty, isTrue);
  });

  test('returns an empty cover when the wardrobe has no items', () async {
    final cover = await container.read(
      wardrobeCoverProvider('wd_abc123').future,
    );

    expect(cover.firstItem, isNull);
    expect(cover.isEmpty, isTrue);
    expect(repository.listCalls, 1);
  });

  test('invalidating the cover provider refetches the first item', () async {
    repository.items.add(testItem());
    await container.read(wardrobeCoverProvider('wd_abc123').future);
    expect(repository.listCalls, 1);

    container.invalidate(wardrobeCoverProvider('wd_abc123'));
    await container.read(wardrobeCoverProvider('wd_abc123').future);

    expect(repository.listCalls, 2);
  });

  test('propagates list failures so the card can show a placeholder', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    Object? captured;
    final subscription = container.listen(wardrobeCoverProvider('wd_abc123'), (
      previous,
      next,
    ) {
      if (next.hasError) {
        captured = next.error;
      }
    }, fireImmediately: true);
    addTearDown(subscription.close);

    await Future<void>.delayed(Duration.zero);
    expect(captured, isA<ApiException>());
  });
}
