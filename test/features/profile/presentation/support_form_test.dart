import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/auth/application/auth_controller.dart';
import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';
import 'package:wardrobe_app/features/profile/data/package_info_device_context.dart';
import 'package:wardrobe_app/features/profile/domain/support_form_kind.dart';
import 'package:wardrobe_app/features/profile/presentation/contact_us_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/report_bug_screen.dart';
import 'package:wardrobe_app/features/profile/presentation/widgets/support_form.dart';

import '../../../helpers/fake_auth_repository.dart';
import '../../../helpers/fake_device_context.dart';
import '../../../helpers/fake_support_repository.dart';

void main() {
  late FakeSupportRepository support;
  late FakeAuthRepository auth;

  setUp(() {
    support = FakeSupportRepository();
    auth = FakeAuthRepository(
      initialUser: const AppUser(uid: 'uid-1', email: 'ada@example.com'),
    );
  });

  tearDown(() => auth.dispose());

  Future<void> pumpForm(WidgetTester tester, {required Widget home}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportRepositoryProvider.overrideWithValue(support),
          deviceContextProvider.overrideWithValue(const FakeDeviceContext()),
          authRepositoryProvider.overrideWithValue(auth),
        ],
        child: MaterialApp(home: home),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('contact form validates empty fields', (tester) async {
    await pumpForm(tester, home: const ContactUsScreen());

    await tester.tap(find.byKey(SupportForm.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Enter a subject.'), findsOneWidget);
    expect(find.text('Enter a message.'), findsOneWidget);
    expect(support.contactCalls, 0);
  });

  testWidgets('contact form submits to POST /support/contact contract', (
    tester,
  ) async {
    await pumpForm(tester, home: const ContactUsScreen());

    expect(
      find.text('Included with this report: 1.0.0+1 · android · Pixel 8 · 14'),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(SupportForm.subjectFieldKey), 'Hello');
    await tester.enterText(
      find.byKey(SupportForm.messageFieldKey),
      'Please help with my wardrobe.',
    );
    await tester.tap(find.byKey(SupportForm.submitButtonKey));
    await tester.pumpAndSettle();

    expect(support.contactCalls, 1);
    expect(support.bugCalls, 0);
    expect(support.lastRequest?.subject, 'Hello');
    expect(support.lastRequest?.body, 'Please help with my wardrobe.');
    expect(support.lastRequest?.replyTo, 'ada@example.com');
    expect(support.lastRequest?.meta, {
      'appVersion': '1.0.0+1',
      'platform': 'android',
      'deviceModel': 'Pixel 8',
      'osVersion': '14',
    });
    expect(
      find.text('Message sent. Thanks for getting in touch.'),
      findsOneWidget,
    );
  });

  testWidgets('bug form submits to the bug repository with context', (
    tester,
  ) async {
    await pumpForm(tester, home: const ReportBugScreen());

    await tester.enterText(find.byKey(SupportForm.subjectFieldKey), 'Crash');
    await tester.enterText(
      find.byKey(SupportForm.messageFieldKey),
      'The add-item screen froze after picking a photo.',
    );
    await tester.tap(find.byKey(SupportForm.submitButtonKey));
    await tester.pumpAndSettle();

    expect(support.bugCalls, 1);
    expect(support.contactCalls, 0);
    expect(support.lastRequest?.subject, 'Crash');
    expect(
      find.text('Bug report sent. Thanks for the details.'),
      findsOneWidget,
    );
  });

  testWidgets('shows a friendly error when the backend is not live', (
    tester,
  ) async {
    support.nextFailure = const ApiException(
      message: 'Not found.',
      code: 'NOT_FOUND',
      statusCode: 404,
    );
    await pumpForm(tester, home: const ContactUsScreen());

    await tester.enterText(find.byKey(SupportForm.subjectFieldKey), 'Hello');
    await tester.enterText(
      find.byKey(SupportForm.messageFieldKey),
      'Please help with my wardrobe.',
    );
    await tester.tap(find.byKey(SupportForm.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(ContactUsScreen), findsOneWidget);
    expect(
      find.text("Support isn't available yet. Please try again later."),
      findsOneWidget,
    );
    expect(find.textContaining('mailto'), findsNothing);
  });

  test('support form kinds do not mention Resend or mailto', () {
    for (final kind in SupportFormKind.values) {
      expect(kind.subtitle.toLowerCase(), isNot(contains('resend')));
      expect(kind.subtitle.toLowerCase(), isNot(contains('mailto')));
    }
  });
}
