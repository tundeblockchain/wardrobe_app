import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/core/widgets/destructive_confirm_dialog.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/ai_try_on_screen.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/ai_profile_picker_image.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/generic_model_card.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/personal_ai_profile_card.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';

import '../../../helpers/date_stamp_matchers.dart';
import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_item_image_picker.dart';

void main() {
  late FakeAiProfileRepository repository;
  late FakeItemImagePicker picker;

  setUp(() {
    repository = FakeAiProfileRepository();
    picker = FakeItemImagePicker(image: FakeItemImagePicker.sample());
  });

  Future<ProviderContainer> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: AppRoutes.aiTryOn,
      routes: [
        GoRoute(
          path: AppRoutes.aiTryOn,
          builder: (context, state) => const AiTryOnScreen(),
        ),
      ],
    );
    final container = ProviderContainer(
      overrides: [
        aiProfileRepositoryProvider.overrideWithValue(repository),
        itemImagePickerProvider.overrideWithValue(picker),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('empty personal state can create a profile', (tester) async {
    await pumpScreen(tester);

    expect(find.byType(AiTryOnScreen), findsOneWidget);
    expectNoCreatedUpdatedDateStamps();
    expect(find.byKey(AiTryOnScreen.personalEmptyKey), findsOneWidget);
    expect(find.text('Create personal profile'), findsOneWidget);

    await tester.tap(find.byKey(AiTryOnScreen.createButtonKey));
    await tester.pumpAndSettle();

    expect(repository.createCalls, 1);
    expect(
      find.byKey(PersonalAiProfileCard.cardKey('profile_1')),
      findsOneWidget,
    );
    expect(find.text('Ready'), findsWidgets);
  });

  testWidgets('shows PROCESSING status on a personal profile', (tester) async {
    repository.personal.add(
      testPersonalProfile(status: AiProfileStatus.processing),
    );
    await pumpScreen(tester);

    expect(find.text('Processing'), findsWidgets);
  });

  testWidgets('shows FAILED status on a personal profile', (tester) async {
    repository.personal.add(
      testPersonalProfile(status: AiProfileStatus.failed),
    );
    await pumpScreen(tester);

    expect(find.text('Failed'), findsWidgets);
  });

  testWidgets('gallery upload reuses the Photo Picker', (tester) async {
    repository.personal.add(testPersonalProfile());
    await pumpScreen(tester);

    await tester.tap(
      find.byKey(PersonalAiProfileCard.galleryKey('profile_personal_1')),
    );
    await tester.pumpAndSettle();

    expect(picker.galleryCalls, 1);
    expect(repository.createUploadCalls, 1);
    expect(repository.uploadCalls, 1);
    expect(repository.attachCalls, 1);
    expect(find.text('1 reference photo'), findsOneWidget);
  });

  testWidgets('delete personal profile after confirm', (tester) async {
    repository.personal.add(testPersonalProfile());
    await pumpScreen(tester);

    await tester.tap(
      find.byKey(PersonalAiProfileCard.deleteKey('profile_personal_1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DestructiveConfirmDialog.confirmButtonKey));
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, 1);
    expect(find.byKey(AiTryOnScreen.personalEmptyKey), findsOneWidget);
  });

  testWidgets('browse and select a GENERIC_MODEL for try-on prep', (
    tester,
  ) async {
    final container = await pumpScreen(tester);

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Alex'),
      80,
      scrollable: scrollable,
    );
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Jordan'), findsOneWidget);
    expect(find.text('Sam'), findsOneWidget);
    expect(find.text('Riley'), findsOneWidget);
    expect(
      find.byKey(AiProfilePickerImage.placeholderKey('profile_generic_01')),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.byKey(GenericModelCard.cardKey('profile_generic_02')),
      80,
      scrollable: scrollable,
    );
    await tester.tap(
      find.byKey(GenericModelCard.cardKey('profile_generic_02')),
    );
    await tester.pumpAndSettle();

    expect(container.read(selectedAiProfileIdProvider), 'profile_generic_02');
    expect(find.byKey(AiTryOnScreen.selectedBannerKey), findsOneWidget);
    expect(find.text('Selected: Jordan'), findsOneWidget);
    expect(find.byKey(AiTryOnScreen.comingSoonKey), findsOneWidget);
    expect(find.text('Open a wardrobe outfit and tap Try on.'), findsOneWidget);
    expect(find.textContaining('aiProfileId'), findsNothing);
    expect(find.textContaining('render API'), findsNothing);
  });
}
