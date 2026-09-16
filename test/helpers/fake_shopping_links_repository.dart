import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';
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
  ApiException? nextFailure;
  Object? nextUnknownFailure;
  int homeCalls = 0;
  int itemCalls = 0;
  String? lastWardrobeId;
  String? lastItemId;

  @override
  Future<List<ShoppingLink>> listHomeShoppingLinks() async {
    homeCalls++;
    _maybeFail();
    return [...home];
  }

  @override
  Future<List<ShoppingLink>> listItemShoppingLinks({
    required String wardrobeId,
    required String itemId,
  }) async {
    itemCalls++;
    lastWardrobeId = wardrobeId;
    lastItemId = itemId;
    _maybeFail();
    return [...(byItem[itemId] ?? const [])];
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
  String? imageUrl,
}) {
  return ShoppingLink(
    title: title,
    url: url,
    price: price,
    merchant: merchant,
    imageUrl: imageUrl,
  );
}
