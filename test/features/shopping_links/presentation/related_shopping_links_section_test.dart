import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/app_fade_in.dart';
import 'package:wardrobe_app/features/shopping_links/application/shopping_links_state.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/presentation/widgets/related_shopping_links_section.dart';
import 'package:wardrobe_app/features/shopping_links/presentation/widgets/shopping_product_card.dart';

import '../../../helpers/fake_shopping_link_opener.dart';
import '../../../helpers/fake_shopping_links_repository.dart';

void main() {
  Future<void> pumpSection(
    WidgetTester tester, {
    required ShoppingLinksState state,
    FakeShoppingLinkOpener? opener,
    bool reduceMotion = false,
    VoidCallback? onRetry,
  }) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shoppingLinkOpenerProvider.overrideWithValue(
            opener ?? FakeShoppingLinkOpener(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(disableAnimations: reduceMotion),
              child: child!,
            );
          },
          home: Scaffold(
            body: RelatedShoppingLinksSection(
              state: state,
              onRetry: onRetry ?? () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('empty state shows heading and copy without cards', (
    tester,
  ) async {
    await pumpSection(tester, state: const ShoppingLinksState());

    expect(find.byKey(RelatedShoppingLinksSection.sectionKey), findsOneWidget);
    expect(find.byKey(RelatedShoppingLinksSection.headingKey), findsOneWidget);
    expect(find.text('Related shopping links'), findsOneWidget);
    expect(find.byKey(RelatedShoppingLinksSection.emptyKey), findsOneWidget);
    expect(find.text('No similar products to shop yet.'), findsOneWidget);
    expect(find.byType(ShoppingProductCard), findsNothing);
  });

  testWidgets('loading uses a non-blocking indicator', (tester) async {
    await pumpSection(tester, state: const ShoppingLinksState(isLoading: true));

    expect(find.byKey(RelatedShoppingLinksSection.loadingKey), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Related shopping links'), findsOneWidget);
  });

  testWidgets('unavailable state offers retry without crashing', (
    tester,
  ) async {
    var retried = false;
    await pumpSection(
      tester,
      state: const ShoppingLinksState(
        errorMessage: 'Shopping links are unavailable right now.',
      ),
      onRetry: () => retried = true,
    );

    expect(find.byKey(RelatedShoppingLinksSection.errorKey), findsOneWidget);
    expect(
      find.text('Shopping links are unavailable right now.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(RelatedShoppingLinksSection.retryKey));
    expect(retried, isTrue);
  });

  testWidgets('product cards open the external url', (tester) async {
    final opener = FakeShoppingLinkOpener();
    final link = testShoppingLink();
    await pumpSection(
      tester,
      opener: opener,
      state: ShoppingLinksState(links: [link]),
    );

    expect(find.byType(ShoppingProductCard), findsOneWidget);
    expect(find.text('Black cotton tee'), findsOneWidget);
    expect(find.text('Example Shop'), findsOneWidget);
    expect(find.text('£12.99'), findsOneWidget);
    expect(find.byKey(ShoppingProductCard.placeholderKey), findsOneWidget);

    await tester.tap(find.byKey(ShoppingProductCard.cardKey(link.url)));
    await tester.pump();
    expect(opener.opened, [Uri.parse(link.url)]);
  });

  testWidgets('reduced motion skips the section fade', (tester) async {
    await pumpSection(
      tester,
      reduceMotion: true,
      state: const ShoppingLinksState(),
    );

    expect(find.byType(AppFadeIn), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
  });
}
