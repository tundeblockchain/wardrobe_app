import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/ai_profile_picker_image.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/generic_model_card.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/personal_ai_profile_card.dart';

import '../../../helpers/fake_ai_profile_repository.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows a burgundy placeholder when get/list has no URL', (
    tester,
  ) async {
    final profile = testGenericModel();

    await pump(tester, AiProfilePickerImage(profile: profile));

    expect(
      find.byKey(AiProfilePickerImage.imageKey(profile.id)),
      findsOneWidget,
    );
    expect(
      find.byKey(AiProfilePickerImage.placeholderKey(profile.id)),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.people_outline), findsOneWidget);
  });

  testWidgets('shows the frontal URL when Backend returns one', (tester) async {
    const url = 'https://cdn.example.com/alex/front.png';
    final profile = testGenericModel(previewImageUrl: url);

    await pump(tester, AiProfilePickerImage(profile: profile));

    expect(find.byKey(AiProfilePickerImage.urlKey(url)), findsOneWidget);
    expect(
      find.byKey(AiProfilePickerImage.placeholderKey(profile.id)),
      findsNothing,
    );
  });

  testWidgets('generic and personal picker cards include the photo slot', (
    tester,
  ) async {
    final model = testGenericModel(
      previewImageUrl: 'https://cdn.example.com/alex/front.png',
    );
    final personal = testPersonalProfile();

    await pump(
      tester,
      Column(
        children: [
          SizedBox(
            width: 180,
            height: 200,
            child: GenericModelCard(
              profile: model,
              selected: true,
              onSelect: () {},
            ),
          ),
          PersonalAiProfileCard(
            profile: personal,
            selected: false,
            busy: false,
            uploading: false,
            deleting: false,
            onSelect: () {},
            onCamera: () {},
            onGallery: () {},
            onDelete: () {},
          ),
        ],
      ),
    );

    expect(find.byKey(AiProfilePickerImage.imageKey(model.id)), findsOneWidget);
    expect(
      find.byKey(AiProfilePickerImage.urlKey(model.pickerImageUrl!)),
      findsOneWidget,
    );
    expect(
      find.byKey(AiProfilePickerImage.placeholderKey(personal.id)),
      findsOneWidget,
    );
  });
}
