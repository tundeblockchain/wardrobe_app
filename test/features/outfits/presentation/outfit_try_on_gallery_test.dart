import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/core/widgets/enlarged_image_popup.dart';
import 'package:wardrobe_app/features/outfits/presentation/widgets/outfit_try_on_gallery.dart';

void main() {
  const latest = 'https://cdn.example.com/try-on/latest.png';
  const older = 'https://cdn.example.com/try-on/older.png';

  Future<void> pumpGallery(
    WidgetTester tester, {
    required List<String> urls,
    String? selectedUrl,
    ValueChanged<String>? onSelect,
  }) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: OutfitTryOnGallery(
            imageUrls: urls,
            selectedUrl: selectedUrl,
            onSelect: onSelect,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('starts on the latest look and can swipe to another hero', (
    tester,
  ) async {
    final selected = <String>[];
    await pumpGallery(
      tester,
      urls: const [latest, older],
      onSelect: selected.add,
    );

    expect(find.byKey(OutfitTryOnGallery.galleryKey), findsOneWidget);
    expect(find.byKey(OutfitTryOnGallery.urlKey(latest)), findsOneWidget);
    expect(find.text('Latest look'), findsOneWidget);

    await tester.drag(
      find.byKey(OutfitTryOnGallery.pageViewKey),
      const Offset(-300, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(OutfitTryOnGallery.urlKey(older)), findsOneWidget);
    expect(find.text('Use as main look'), findsOneWidget);
    expect(selected, contains(older));
  });

  testWidgets('tapping a slide opens the enlarged popup', (tester) async {
    await pumpGallery(tester, urls: const [latest, older]);

    await tester.tap(find.byKey(OutfitTryOnGallery.urlKey(latest)));
    await tester.pumpAndSettle();

    expect(find.byKey(EnlargedImagePopup.dialogKey), findsOneWidget);
  });
}
