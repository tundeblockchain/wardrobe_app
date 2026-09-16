import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/application/item_scope.dart';
import 'package:wardrobe_app/features/shopping_links/application/item_shopping_links_controller.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';

import '../../../helpers/fake_shopping_links_repository.dart';

void main() {
  late FakeShoppingLinksRepository repository;
  late ProviderContainer container;
  const scope = ItemScope(wardrobeId: 'wd_abc123', itemId: 'item_xyz123');

  setUp(() {
    repository = FakeShoppingLinksRepository(
      byItem: {
        'item_xyz123': [testShoppingLink()],
      },
    );
    container = ProviderContainer.test(
      overrides: [
        shoppingLinksRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads links for the item', () async {
    container.read(itemShoppingLinksControllerProvider(scope));
    await settle();

    final state = container.read(itemShoppingLinksControllerProvider(scope));
    expect(state.links, hasLength(1));
    expect(repository.itemCalls, 1);
    expect(repository.lastWardrobeId, 'wd_abc123');
    expect(repository.lastItemId, 'item_xyz123');
  });

  test('failures stay local and do not throw', () async {
    repository.nextFailure = const ApiException(
      message: 'Item shopping links failed.',
      code: 'UPSTREAM_ERROR',
    );

    container.read(itemShoppingLinksControllerProvider(scope));
    await settle();

    final state = container.read(itemShoppingLinksControllerProvider(scope));
    expect(state.errorMessage, 'Item shopping links failed.');
    expect(state.isUnavailable, isTrue);
  });
}
