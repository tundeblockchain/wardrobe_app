import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/shopping_links/data/shopping_link_dtos.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_links_contract.dart';

void main() {
  group('shoppingPriceFromJson', () {
    test('keeps a display string and stringifies numbers', () {
      expect(shoppingPriceFromJson('£24.99'), '£24.99');
      expect(shoppingPriceFromJson('  12.00  '), '12.00');
      expect(shoppingPriceFromJson(25), '25');
      expect(shoppingPriceFromJson(24.5), '24.5');
      expect(shoppingPriceFromJson(null), isNull);
      expect(shoppingPriceFromJson(''), isNull);
    });
  });

  group('ShoppingLink.displayPrice', () {
    test('appends currency when price has no symbol', () {
      expect(
        const ShoppingLink(
          title: 'Tee',
          url: 'https://shop.example.com/tee',
          price: '12.99',
          currency: 'GBP',
        ).displayPrice,
        '12.99 GBP',
      );
    });

    test('does not double a price that already includes currency', () {
      expect(
        const ShoppingLink(
          title: 'Tee',
          url: 'https://shop.example.com/tee',
          price: '£12.99',
          currency: 'GBP',
        ).displayPrice,
        '£12.99',
      );
    });
  });

  group('tryParseShoppingUrl', () {
    test('accepts http(s) and rejects other schemes', () {
      expect(
        tryParseShoppingUrl('https://shop.example.com/p')?.host,
        'shop.example.com',
      );
      expect(tryParseShoppingUrl('javascript:alert(1)'), isNull);
      expect(tryParseShoppingUrl(''), isNull);
    });
  });

  group('ShoppingLinksContract', () {
    test('clamps home query to Backend max', () {
      expect(
        ShoppingLinksContract.homeQueryParameters(limit: 99, linksPerItem: 99),
        {'limit': '10', 'linksPerItem': '12'},
      );
      expect(ShoppingLinksContract.homeQueryParameters(), {
        'limit': '5',
        'linksPerItem': '8',
      });
    });
  });

  group('parseItemShoppingLinks', () {
    const link = {
      'title': 'Black cotton tee',
      'url': 'https://shop.example.com/tee',
      'merchant': 'Example Shop',
      'price': '12.99',
      'currency': 'GBP',
      'imageUrl': 'https://cdn.example.com/tee.jpg',
    };

    test('maps the locked item 200 envelope', () {
      final item = parseItemShoppingLinks({
        'itemId': 'item_xyz123',
        'wardrobeId': 'wd_abc123',
        'keywords': ['black tee', 'cotton t-shirt'],
        'cached': true,
        'links': [link],
      });

      expect(item.itemId, 'item_xyz123');
      expect(item.wardrobeId, 'wd_abc123');
      expect(item.keywords, ['black tee', 'cotton t-shirt']);
      expect(item.cached, isTrue);
      expect(item.links, hasLength(1));
      expect(item.links.single.title, 'Black cotton tee');
      expect(item.links.single.price, '12.99');
      expect(item.links.single.currency, 'GBP');
      expect(item.links.single.displayPrice, '12.99 GBP');
      expect(item.warning, isNull);
    });

    test('soft-omits unset optionals and JSON nulls', () {
      final item = parseItemShoppingLinks({
        'itemId': 'item_xyz123',
        'wardrobeId': 'wd_abc123',
        'keywords': <String>[],
        'cached': false,
        'links': [
          {'title': 'Navy knit', 'url': 'https://knit.example.com/navy'},
        ],
      });

      expect(item.links.single.merchant, isNull);
      expect(item.links.single.price, isNull);
      expect(item.links.single.currency, isNull);
      expect(item.links.single.imageUrl, isNull);
    });

    test('maps SHOPPING_UPSTREAM_UNAVAILABLE on empty links', () {
      final item = parseItemShoppingLinks({
        'itemId': 'item_xyz123',
        'wardrobeId': 'wd_abc123',
        'keywords': <String>[],
        'cached': false,
        'links': <Map<String, dynamic>>[],
        'warning': {
          'code': ShoppingLinksWarning.upstreamUnavailable,
          'message': 'Similar products are unavailable right now.',
        },
      });

      expect(item.links, isEmpty);
      expect(item.warning?.isUpstreamUnavailable, isTrue);
    });

    test('skips links missing title/url or with a non-http url', () {
      final item = parseItemShoppingLinks({
        'itemId': 'item_xyz123',
        'wardrobeId': 'wd_abc123',
        'links': [
          link,
          {'title': 'No url'},
          {'title': 'Bad scheme', 'url': 'javascript:alert(1)'},
        ],
      });
      expect(item.links, hasLength(1));
    });
  });

  group('parseHomeShoppingLinks', () {
    test('maps { items: [...] } and flattens links', () {
      final home = parseHomeShoppingLinks({
        'items': [
          {
            'itemId': 'item_1',
            'wardrobeId': 'wd_1',
            'keywords': ['tee'],
            'cached': false,
            'links': [
              {
                'title': 'Black cotton tee',
                'url': 'https://shop.example.com/tee',
              },
            ],
          },
          {
            'itemId': 'item_2',
            'wardrobeId': 'wd_1',
            'keywords': <String>[],
            'cached': true,
            'links': [
              {'title': 'Navy knit', 'url': 'https://knit.example.com/navy'},
            ],
          },
        ],
      });

      expect(home.items, hasLength(2));
      expect(home.flattenedLinks.map((link) => link.title), [
        'Black cotton tee',
        'Navy knit',
      ]);
      expect(home.upstreamWarning, isNull);
    });

    test('empty items is a successful empty home payload', () {
      final home = parseHomeShoppingLinks({'items': <Map<String, dynamic>>[]});
      expect(home.items, isEmpty);
      expect(home.flattenedLinks, isEmpty);
      expect(home.upstreamWarning, isNull);
    });

    test('malformed payloads become empty, never throw', () {
      expect(parseHomeShoppingLinks(null).items, isEmpty);
      expect(parseHomeShoppingLinks('nope').items, isEmpty);
      expect(parseItemShoppingLinks(null).links, isEmpty);
    });
  });
}
