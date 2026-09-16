import 'package:wardrobe_app/features/shopping_links/domain/shopping_link_opener.dart';

/// Records opened shopping URLs in widget tests.
class FakeShoppingLinkOpener implements ShoppingLinkOpener {
  final opened = <Uri>[];
  bool result = true;

  @override
  Future<bool> open(Uri url) async {
    opened.add(url);
    return result;
  }
}
