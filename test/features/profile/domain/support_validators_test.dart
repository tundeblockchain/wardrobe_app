import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/profile/domain/support_validators.dart';

void main() {
  group('SupportValidators.subject', () {
    test('requires a non-empty subject', () {
      expect(SupportValidators.subject(null), 'Enter a subject.');
      expect(SupportValidators.subject('   '), 'Enter a subject.');
    });

    test('rejects subjects over the max length', () {
      final tooLong = 'x' * (SupportValidators.maxSubjectLength + 1);
      expect(
        SupportValidators.subject(tooLong),
        'Subject must be ${SupportValidators.maxSubjectLength} characters or fewer.',
      );
    });

    test('accepts a trimmed subject', () {
      expect(SupportValidators.subject('  Hello  '), isNull);
    });
  });

  group('SupportValidators.message', () {
    test('requires a message', () {
      expect(SupportValidators.message(null), 'Enter a message.');
      expect(SupportValidators.message(''), 'Enter a message.');
    });

    test('rejects messages that are too short', () {
      expect(
        SupportValidators.message('short'),
        'Message must be at least ${SupportValidators.minMessageLength} characters.',
      );
    });

    test('rejects messages over the max length', () {
      final tooLong = 'x' * (SupportValidators.maxMessageLength + 1);
      expect(
        SupportValidators.message(tooLong),
        'Message must be ${SupportValidators.maxMessageLength} characters or fewer.',
      );
    });

    test('accepts a valid message', () {
      expect(
        SupportValidators.message('This is long enough to submit.'),
        isNull,
      );
    });
  });
}
