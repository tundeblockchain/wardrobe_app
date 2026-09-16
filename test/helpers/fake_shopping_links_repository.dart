import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_links_contract.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_links_repository.dart';

/// In-memory [ShoppingLinksRepository] for unit tests.
class FakeShoppingLinksRepository implements ShoppingLinksRepository {
  FakeShoppingLinksRepository({
    List<ShoppingLink>? home,
    Map<String, List<ShoppingLink>>? byItem,
  }) : home = [...?home],
       byItem = {
         if (byItem != null)
           for (final entry in byItem.entries) entry.key: [...entry.value],
       };

  final List<ShoppingLink> home;
  final Map<String, List<ShoppingLink>> byItem;
  ShoppingLinksWarning? homeWarning;
  ShoppingLinksWarning? itemWarning;
  ApiException? nextFailure;
  Object? nextUnknownFailure;
  int homeCalls = 0;
  int itemCalls = 0;
  String? lastWardrobeId;
  String? lastItemId;
  int? lastLimit;
  int? lastLinksPerItem;

  @override
  Future<HomeShoppingLinks> listHomeShoppingLinks({
    int limit = ShoppingLinksContract.defaultLimit,
    int linksPerItem = ShoppingLinksContract.defaultLinksPerItem,
  }) async {
    homeCalls++;
    lastLimit = limit;
    lastLinksPerItem = linksPerItem;
    _maybeFail();
    if (home.isEmpty && homeWarning == null) {
      return const HomeShoppingLinks();
    }
    return HomeShoppingLinks(
      items: [
        ShoppingLinksItemResult(
          itemId: 'item_xyz123',
          wardrobeId: 'wd_abc123',
          links: [...home],
          warning: homeWarning,
        ),
      ],
    );
  }

  @override
  Future<ShoppingLinksItemResult> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  }) async {
    itemCalls++;
    lastWardrobeId = wardrobeId;
    lastItemId = itemId;
    _maybeFail();
    return ShoppingLinksItemResult(
      itemId: itemId,
      wardrobeId: wardrobeId,
      links: [...(byItem[itemId] ?? const [])],
      warning: itemWarning,
    );
  }

  void _maybeFail() {
    final unknown = nextUnknownFailure;
    if (unknown != null) {
      nextUnknownFailure = null;
      throw unknown;
    }
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

ShoppingLink testShoppingLink({
  String title = 'Black cotton tee',
  String url = 'https://shop.example.com/tee',
  String? price = '£12.99',
  String? merchant = 'Example Shop',
  String? currency,
  String? imageUrl,
}) {
  return ShoppingLink(
    title: title,
    url: url,
    price: price,
    merchant: merchant,
    currency: currency,
    imageUrl: imageUrl,
  );
}
