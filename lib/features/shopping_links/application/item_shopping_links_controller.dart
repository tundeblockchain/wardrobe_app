import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';
import '../../items/application/item_scope.dart';
import 'home_shopping_links_controller.dart';
import 'shopping_links_state.dart';

/// Item-scoped shopping links. Failures stay on this section only.
class ItemShoppingLinksController extends Notifier<ShoppingLinksState> {
  ItemShoppingLinksController(this.scope);

  final ItemScope scope;

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
      load: (repository) => repository.listItemShoppingLinks(
        wardrobeId: scope.wardrobeId,
        itemId: scope.itemId,
      ),
    );
  }
}

final itemShoppingLinksControllerProvider =
    NotifierProvider.family<
      ItemShoppingLinksController,
      ShoppingLinksState,
      ItemScope
    >(ItemShoppingLinksController.new);
