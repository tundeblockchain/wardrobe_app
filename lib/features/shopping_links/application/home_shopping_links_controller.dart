import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../data/dio_shopping_links_repository.dart';
import '../domain/shopping_link.dart';
import '../domain/shopping_links_repository.dart';
import 'shopping_links_state.dart';

const shoppingLinksUnavailableMessage =
    'Shopping links are unavailable right now.';

Future<void> refreshShoppingLinks({
  required Ref ref,
  required ShoppingLinksState Function() readState,
  required void Function(ShoppingLinksState next) writeState,
  required Future<(List<ShoppingLink>, ShoppingLinksWarning?)> Function(
    ShoppingLinksRepository repository,
  )
  load,
}) async {
  writeState(readState().copyWith(isLoading: true, clearError: true));
  try {
    final (links, warning) = await load(
      ref.read(shoppingLinksRepositoryProvider),
    );
    if (!ref.mounted) {
      return;
    }
    if (links.isEmpty && warning != null) {
      writeState(
        readState().copyWith(
          isLoading: false,
          links: List<ShoppingLink>.unmodifiable(links),
          errorMessage: warning.message,
        ),
      );
      return;
    }
    writeState(
      readState().copyWith(
        isLoading: false,
        links: List<ShoppingLink>.unmodifiable(links),
        clearError: true,
      ),
    );
  } on ApiException catch (error) {
    if (!ref.mounted) {
      return;
    }
    writeState(
      readState().copyWith(isLoading: false, errorMessage: error.message),
    );
  } catch (_) {
    if (!ref.mounted) {
      return;
    }
    writeState(
      readState().copyWith(
        isLoading: false,
        errorMessage: shoppingLinksUnavailableMessage,
      ),
    );
  }
}

/// Home mixed shopping links. Failures never block wardrobe browsing.
class HomeShoppingLinksController extends Notifier<ShoppingLinksState> {
  @override
  ShoppingLinksState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const ShoppingLinksState();
    }
    Future<void>.microtask(refresh);
    return const ShoppingLinksState(isLoading: true);
  }

  Future<void> refresh() {
    return refreshShoppingLinks(
      ref: ref,
      readState: () => state,
      writeState: (next) => state = next,
      load: (repository) async {
        final home = await repository.listHomeShoppingLinks();
        return (home.flattenedLinks, home.upstreamWarning);
      },
    );
  }
}

final homeShoppingLinksControllerProvider =
    NotifierProvider<HomeShoppingLinksController, ShoppingLinksState>(
      HomeShoppingLinksController.new,
    );
