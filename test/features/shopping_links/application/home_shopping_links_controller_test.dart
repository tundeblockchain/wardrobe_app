import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/session/session_gate.dart';
import 'package:wardrobe_app/features/shopping_links/application/home_shopping_links_controller.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';

import '../../../helpers/fake_shopping_links_repository.dart';

void main() {
  late FakeShoppingLinksRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeShoppingLinksRepository();
    container = ProviderContainer.test(
      overrides: [
        shoppingLinksRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads mixed home links', () async {
    repository.home.add(testShoppingLink());

    final first = container.read(homeShoppingLinksControllerProvider);
    expect(first.isLoading, isTrue);

    await settle();

    final state = container.read(homeShoppingLinksControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.links, hasLength(1));
    expect(state.links.single.title, 'Black cotton tee');
    expect(repository.homeCalls, 1);
    expect(repository.lastLimit, 5);
    expect(repository.lastLinksPerItem, 8);
  });

  test('upstream warning on empty home is unavailable, not a crash', () async {
    repository.homeWarning = const ShoppingLinksWarning(
      code: ShoppingLinksWarning.upstreamUnavailable,
      message: 'Similar products are unavailable right now.',
    );

    container.read(homeShoppingLinksControllerProvider);
    await settle();

    final state = container.read(homeShoppingLinksControllerProvider);
    expect(state.links, isEmpty);
    expect(state.isUnavailable, isTrue);
    expect(state.errorMessage, contains('unavailable'));
  });

  test('ApiException stays on this section as unavailable', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    container.read(homeShoppingLinksControllerProvider);
    await settle();

    final state = container.read(homeShoppingLinksControllerProvider);
    expect(state.errorMessage, contains('connection'));
    expect(state.isUnavailable, isTrue);
    expect(state.links, isEmpty);
  });

  test('unknown failures use the soft unavailable copy', () async {
    repository.nextUnknownFailure = StateError('boom');

    container.read(homeShoppingLinksControllerProvider);
    await settle();

    final state = container.read(homeShoppingLinksControllerProvider);
    expect(state.errorMessage, shoppingLinksUnavailableMessage);
    expect(state.isUnavailable, isTrue);
  });

  test('empty list is a successful empty state, not unavailable', () async {
    container.read(homeShoppingLinksControllerProvider);
    await settle();

    final state = container.read(homeShoppingLinksControllerProvider);
    expect(state.isEmpty, isTrue);
    expect(state.isUnavailable, isFalse);
    expect(state.errorMessage, isNull);
  });

  test('signed-out session does not fetch', () async {
    container.read(sessionGateProvider.notifier).markSignedOut();
    container.read(homeShoppingLinksControllerProvider);
    await settle();

    expect(repository.homeCalls, 0);
    expect(
      container.read(homeShoppingLinksControllerProvider).isLoading,
      isFalse,
    );
  });
}
