import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';
import 'package:wardrobe_app/features/items/domain/item_subcategory_patch.dart';
import 'package:wardrobe_app/features/items/presentation/edit_item_screen.dart';
import 'package:wardrobe_app/features/items/presentation/widgets/item_subcategory_field.dart';

import '../../../helpers/fake_item_image_picker.dart';
import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_upload_repository.dart';
import '../../../helpers/item_processing_poll_overrides.dart';

void main() {
  testWidgets('edit item can save with subcategory set to none', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final items = FakeItemRepository(seed: [testItem()]);
    final router = GoRouter(
      initialLocation: '/edit',
      routes: [
        GoRoute(
          path: '/edit',
          builder: (context, state) => const EditItemScreen(
            wardrobeId: 'wd_abc123',
            itemId: 'item_xyz123',
          ),
        ),
        GoRoute(
          path: '/wardrobes/:wardrobeId/items/:itemId',
          builder: (context, state) => const Scaffold(body: Text('detail')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemRepositoryProvider.overrideWithValue(items),
          uploadRepositoryProvider.overrideWithValue(FakeUploadRepository()),
          itemImagePickerProvider.overrideWithValue(FakeItemImagePicker()),
          ...itemProcessingPollTestOverrides(),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(EditItemScreen.subcategoryFieldKey), findsOneWidget);

    await tester.tap(find.byKey(ItemSubcategoryField.fieldKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('None').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(EditItemScreen.submitButtonKey));
    await tester.pumpAndSettle();

    expect(items.lastSubcategoryPatch, const ItemSubcategoryPatch.clear());
    expect(find.text('detail'), findsOneWidget);
  });
}
