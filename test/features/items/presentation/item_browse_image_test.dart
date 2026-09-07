import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_browse_image.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/tiny_png.dart';

void main() {
  Future<void> pumpImage(
    WidgetTester tester, {
    required Item item,
    bool withLocalPreview = false,
  }) async {
    tester.view.physicalSize = const Size(300, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: SizedBox(
          width: 300,
          height: 400,
          child: ItemBrowseImage(
            item: item,
            localPreviewBytes: withLocalPreview ? tinyPngBytes : null,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows the original upload bytes while PROCESSING', (
    tester,
  ) async {
    final item = testItem(processingStatus: ItemProcessingStatus.processing);

    await pumpImage(tester, item: item, withLocalPreview: true);

    expect(find.byKey(ItemBrowseImage.imageKey(item.id)), findsOneWidget);
    expect(find.byKey(ItemBrowseImage.localSourceKey(item.id)), findsOneWidget);
    expect(
      find.byKey(ItemBrowseImage.processingIndicatorKey(item.id)),
      findsOneWidget,
    );
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.checkroom_outlined), findsNothing);
  });

  testWidgets('shows an original network URL while PROCESSING', (tester) async {
    final item = testItem(
      originalImageKey: 'https://cdn.example.com/original.jpg',
      processingStatus: ItemProcessingStatus.processing,
    );

    await pumpImage(tester, item: item);

    expect(
      find.byKey(ItemBrowseImage.sourceKey(item.originalImageKey!)),
      findsOneWidget,
    );
    expect(
      find.byKey(ItemBrowseImage.processingIndicatorKey(item.id)),
      findsOneWidget,
    );
  });

  testWidgets('keeps the original image on FAILED without a processing bar', (
    tester,
  ) async {
    final item = testItem(
      originalImageKey: 'https://cdn.example.com/original.jpg',
      processingStatus: ItemProcessingStatus.failed,
      processingError: 'Background removal failed.',
    );

    await pumpImage(tester, item: item, withLocalPreview: true);

    expect(find.byKey(ItemBrowseImage.imageKey(item.id)), findsOneWidget);
    expect(
      find.byKey(ItemBrowseImage.sourceKey(item.originalImageKey!)),
      findsOneWidget,
    );
    expect(
      find.byKey(ItemBrowseImage.processingIndicatorKey(item.id)),
      findsNothing,
    );
  });

  testWidgets('switches to the processed URL when READY', (tester) async {
    final item = testItem(
      originalImageKey: 'https://cdn.example.com/original.jpg',
      processedImageKey: 'https://cdn.example.com/processed.png',
    );

    await pumpImage(tester, item: item, withLocalPreview: true);

    expect(
      find.byKey(ItemBrowseImage.sourceKey(item.processedImageKey!)),
      findsOneWidget,
    );
    expect(find.byKey(ItemBrowseImage.localSourceKey(item.id)), findsNothing);
    expect(
      find.byKey(ItemBrowseImage.processingIndicatorKey(item.id)),
      findsNothing,
    );
  });
}
