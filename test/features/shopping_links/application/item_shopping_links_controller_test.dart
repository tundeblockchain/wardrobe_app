import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/session/session_gate.dart';
import 'package:wardrobe_app/features/items/application/item_scope.dart';
import 'package:wardrobe_app/features/shopping_links/application/item_shopping_links_controller.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';

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
    expect(repository.homeCalls, 0);
    expect(repository.lastWardrobeId, 'wd_abc123');
    expect(repository.lastItemId, 'item_xyz123');
  });

  test('upstream warning on empty item links is unavailable', () async {
    repository.itemWarning = const ShoppingLinksWarning(
      code: ShoppingLinksWarning.upstreamUnavailable,
      message: 'Similar products are unavailable right now.',
    );
    repository.byItem['item_xyz123']?.clear();

    container.read(itemShoppingLinksControllerProvider(scope));
    await settle();

    final state = container.read(itemShoppingLinksControllerProvider(scope));
    expect(state.isUnavailable, isTrue);
    expect(state.links, isEmpty);
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

  test('unknown failures use the soft unavailable copy', () async {
    repository.nextUnknownFailure = StateError('boom');

    container.read(itemShoppingLinksControllerProvider(scope));
    await settle();

    final state = container.read(itemShoppingLinksControllerProvider(scope));
    expect(state.errorMessage, shoppingLinksUnavailableMessage);
    expect(state.isUnavailable, isTrue);
  });

  test('empty list is a successful empty state, not unavailable', () async {
    repository.byItem['item_xyz123']?.clear();

    container.read(itemShoppingLinksControllerProvider(scope));
    await settle();

    final state = container.read(itemShoppingLinksControllerProvider(scope));
    expect(state.isEmpty, isTrue);
    expect(state.isUnavailable, isFalse);
    expect(state.errorMessage, isNull);
    expect(repository.itemCalls, 1);
    expect(repository.homeCalls, 0);
  });

  test('signed-out session does not fetch', () async {
    container.read(sessionGateProvider.notifier).markSignedOut();
    container.read(itemShoppingLinksControllerProvider(scope));
    await settle();

    expect(repository.itemCalls, 0);
    expect(repository.homeCalls, 0);
    expect(
      container.read(itemShoppingLinksControllerProvider(scope)).isLoading,
      isFalse,
    );
  });
}
