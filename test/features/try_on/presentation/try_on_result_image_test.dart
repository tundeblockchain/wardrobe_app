import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/theme/app_theme.dart';
import 'package:wardrobe_app/features/try_on/presentation/widgets/try_on_result_image.dart';

void main() {
  testWidgets('try-on result letterboxes with contain', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const url = 'https://cdn.example.com/try-on/outfit_123.png';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: TryOnResultImage(imageUrl: url)),
      ),
    );
    await tester.pump();

    expect(find.byKey(TryOnResultImage.imageKey), findsOneWidget);
    expect(find.byKey(TryOnResultImage.urlKey(url)), findsOneWidget);
    expect(tester.widget<Image>(find.byType(Image)).fit, BoxFit.contain);
  });
}
