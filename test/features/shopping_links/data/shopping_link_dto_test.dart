import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/shopping_links/data/shopping_link_dtos.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';

void main() {
  group('shoppingPriceFromJson', () {
    test('keeps a display string', () {
      expect(shoppingPriceFromJson('£24.99'), '£24.99');
      expect(shoppingPriceFromJson('  12.00  '), '12.00');
    });

    test('stringifies numbers and treats blank as null', () {
      expect(shoppingPriceFromJson(25), '25');
      expect(shoppingPriceFromJson(24.5), '24.5');
      expect(shoppingPriceFromJson(24.0), '24');
      expect(shoppingPriceFromJson(''), isNull);
      expect(shoppingPriceFromJson('   '), isNull);
      expect(shoppingPriceFromJson(null), isNull);
    });
  });

  group('tryParseShoppingUrl', () {
    test('accepts http(s) and rejects other schemes', () {
      expect(
        tryParseShoppingUrl('https://shop.example.com/p')?.host,
        'shop.example.com',
      );
      expect(tryParseShoppingUrl('http://shop.example.com/p'), isNotNull);
      expect(tryParseShoppingUrl('javascript:alert(1)'), isNull);
      expect(tryParseShoppingUrl('ftp://files.example.com'), isNull);
      expect(tryParseShoppingUrl(''), isNull);
      expect(tryParseShoppingUrl(null), isNull);
    });
  });

  group('parseShoppingLinkList', () {
    const payload = {
      'title': 'Black cotton tee',
      'price': '£12.99',
      'merchant': 'Example Shop',
      'url': 'https://shop.example.com/tee',
      'imageUrl': 'https://cdn.example.com/tee.jpg',
    };

    test('unwraps { links: [...] }', () {
      final links = parseShoppingLinkList({
        'links': [payload],
      });
      expect(links, hasLength(1));
      expect(links.single.title, 'Black cotton tee');
      expect(links.single.price, '£12.99');
      expect(links.single.merchant, 'Example Shop');
      expect(links.single.url, 'https://shop.example.com/tee');
      expect(links.single.imageUrl, 'https://cdn.example.com/tee.jpg');
    });

    test('accepts shoppingLinks alias, a bare array, and null as empty', () {
      expect(
        parseShoppingLinkList({
          'shoppingLinks': [payload],
        }),
        hasLength(1),
      );
      expect(parseShoppingLinkList([payload]), hasLength(1));
      expect(parseShoppingLinkList(null), isEmpty);
      expect(parseShoppingLinkList(<String, dynamic>{}), isEmpty);
      expect(parseShoppingLinkList('nope'), isEmpty);
    });

    test('maps numeric price and field aliases', () {
      final links = parseShoppingLinkList([
        {
          'name': 'Navy knit',
          'price': 19.5,
          'store': 'Knit Co',
          'href': 'https://knit.example.com/navy',
          'image_url': 'https://cdn.example.com/navy.jpg',
        },
      ]);
      expect(links.single.title, 'Navy knit');
      expect(links.single.price, '19.5');
      expect(links.single.merchant, 'Knit Co');
      expect(links.single.url, 'https://knit.example.com/navy');
      expect(links.single.imageUrl, 'https://cdn.example.com/navy.jpg');
    });

    test('skips entries missing title/url or with a non-http url', () {
      final links = parseShoppingLinkList([
        payload,
        {'title': 'No url'},
        {'title': 'Bad scheme', 'url': 'javascript:alert(1)'},
        'not-a-map',
      ]);
      expect(links, hasLength(1));
      expect(links.single.title, 'Black cotton tee');
    });
  });
}
