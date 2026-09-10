import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_context.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_validators.dart';

void main() {
  group('empty fields are valid', () {
    test('null and blank pass for every measurement', () {
      expect(AiProfileBodyValidators.height(null), isNull);
      expect(AiProfileBodyValidators.height(''), isNull);
      expect(AiProfileBodyValidators.height('  '), isNull);
      expect(AiProfileBodyValidators.age(null), isNull);
      expect(AiProfileBodyValidators.age(''), isNull);
      expect(AiProfileBodyValidators.bust(null), isNull);
      expect(AiProfileBodyValidators.hips(null), isNull);
      expect(AiProfileBodyValidators.size(null), isNull);
      expect(AiProfileBodyValidators.size(''), isNull);
      expect(AiProfileBodyValidators.weight(null), isNull);
    });

    test('parseForm maps blanks to an empty context', () {
      expect(
        AiProfileBodyValidators.parseForm(
          height: ' ',
          age: '',
          bust: '',
          hips: '',
          size: '  ',
          weight: '',
        ),
        AiProfileBodyContext.empty,
      );
    });
  });

  group('light range checks', () {
    test('height accepts centimetres in range', () {
      expect(AiProfileBodyValidators.height('170'), isNull);
      expect(AiProfileBodyValidators.height('170.5'), isNull);
      expect(AiProfileBodyValidators.height('49'), isNotNull);
      expect(AiProfileBodyValidators.height('251'), isNotNull);
      expect(AiProfileBodyValidators.height('abc'), isNotNull);
    });

    test('age requires a whole number in range', () {
      expect(AiProfileBodyValidators.age('28'), isNull);
      expect(AiProfileBodyValidators.age('0'), isNotNull);
      expect(AiProfileBodyValidators.age('121'), isNotNull);
      expect(AiProfileBodyValidators.age('28.5'), isNotNull);
    });

    test('bust and hips accept centimetres in range', () {
      expect(AiProfileBodyValidators.bust('90'), isNull);
      expect(AiProfileBodyValidators.bust('39'), isNotNull);
      expect(AiProfileBodyValidators.hips('100'), isNull);
      expect(AiProfileBodyValidators.hips('201'), isNotNull);
    });

    test('weight accepts kilograms in range', () {
      expect(AiProfileBodyValidators.weight('65'), isNull);
      expect(AiProfileBodyValidators.weight('19'), isNotNull);
      expect(AiProfileBodyValidators.weight('401'), isNotNull);
    });

    test('size is optional with a short max length', () {
      expect(AiProfileBodyValidators.size('M'), isNull);
      expect(AiProfileBodyValidators.size('10'), isNull);
      expect(AiProfileBodyValidators.size('x' * 17), isNotNull);
    });
  });

  test('parseForm maps filled fields onto WARDROBE-80 names', () {
    final parsed = AiProfileBodyValidators.parseForm(
      height: '170',
      age: '28',
      bust: '90.5',
      hips: '100',
      size: ' M ',
      weight: '65',
    );

    expect(parsed.height, 170);
    expect(parsed.age, 28);
    expect(parsed.bust, 90.5);
    expect(parsed.hips, 100);
    expect(parsed.size, 'M');
    expect(parsed.weight, 65);
    expect(parsed.isEmpty, isFalse);
  });

  test('summary lists filled fields only', () {
    expect(AiProfileBodyContext.empty.summary, isNull);
    expect(
      const AiProfileBodyContext(height: 170, size: 'M').summary,
      '170 cm · size M',
    );
  });
}
