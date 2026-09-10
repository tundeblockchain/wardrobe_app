import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/ai_profiles/presentation/widgets/ai_profile_picker_image.dart';
import 'package:wardrobe_app/features/try_on/presentation/widgets/try_on_persona_card.dart';

import '../../../helpers/fake_ai_profile_repository.dart';

void main() {
  testWidgets('shows a large cover-cropped frontal photo and selects on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const url = 'https://cdn.example.com/alex/front.png';
    final profile = testGenericModel(previewImageUrl: url);
    var selected = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: TryOnPersonaCard(
              profile: profile,
              selected: false,
              onSelect: () => selected = true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(TryOnPersonaCard.cardKey(profile.id)), findsOneWidget);
    expect(find.byKey(TryOnPersonaCard.chipKey(profile.id)), findsOneWidget);
    expect(find.byKey(AiProfilePickerImage.urlKey(url)), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.byType(FilterChip), findsNothing);
    expect(find.byType(ClipOval), findsNothing);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.cover);

    await tester.tap(find.byKey(TryOnPersonaCard.cardKey(profile.id)));
    expect(selected, isTrue);
  });
}
