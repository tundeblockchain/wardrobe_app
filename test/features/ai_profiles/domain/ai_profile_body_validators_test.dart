import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_context.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_validators.dart';

void main() {
  group('empty fields are valid', () {
    test('null and blank pass for every measurement', () {
      expect(AiProfileBodyValidators.heightCm(null), isNull);
      expect(AiProfileBodyValidators.heightCm(''), isNull);
      expect(AiProfileBodyValidators.heightCm('  '), isNull);
      expect(AiProfileBodyValidators.weightKg(null), isNull);
      expect(AiProfileBodyValidators.bustCm(null), isNull);
      expect(AiProfileBodyValidators.hipsCm(null), isNull);
      expect(AiProfileBodyValidators.clothingSize(null), isNull);
      expect(AiProfileBodyValidators.clothingSize(''), isNull);
      expect(AiProfileBodyValidators.ageYears(null), isNull);
      expect(AiProfileBodyValidators.ageYears(''), isNull);
      expect(AiProfileBodyValidators.bodyType(null), isNull);
      expect(AiProfileBodyValidators.gender(null), isNull);
    });

    test('parseForm maps blanks to an empty context', () {
      expect(
        AiProfileBodyValidators.parseForm(
          heightCm: ' ',
          weightKg: '',
          bustCm: '',
          hipsCm: '',
          clothingSize: '  ',
          ageYears: '',
          bodyType: '',
          gender: '  ',
        ),
        AiProfileBodyContext.empty,
      );
    });
  });

  group('light range checks', () {
    test('heightCm accepts centimetres in range', () {
      expect(AiProfileBodyValidators.heightCm('170'), isNull);
      expect(AiProfileBodyValidators.heightCm('170.5'), isNull);
      expect(AiProfileBodyValidators.heightCm('49'), isNotNull);
      expect(AiProfileBodyValidators.heightCm('251'), isNotNull);
      expect(AiProfileBodyValidators.heightCm('abc'), isNotNull);
    });

    test('weightKg accepts kilograms in Backend range', () {
      expect(AiProfileBodyValidators.weightKg('65'), isNull);
      expect(AiProfileBodyValidators.weightKg('15'), isNull);
      expect(AiProfileBodyValidators.weightKg('19'), isNull);
      expect(AiProfileBodyValidators.weightKg('14'), isNotNull);
      expect(AiProfileBodyValidators.weightKg('401'), isNotNull);
    });

    test('bustCm and hipsCm accept centimetres in range', () {
      expect(AiProfileBodyValidators.bustCm('90'), isNull);
      expect(AiProfileBodyValidators.bustCm('39'), isNotNull);
      expect(AiProfileBodyValidators.hipsCm('100'), isNull);
      expect(AiProfileBodyValidators.hipsCm('201'), isNotNull);
    });

    test('clothingSize is optional with a 32-character max', () {
      expect(AiProfileBodyValidators.clothingSize('M'), isNull);
      expect(AiProfileBodyValidators.clothingSize('10'), isNull);
      expect(AiProfileBodyValidators.clothingSize('x' * 17), isNull);
      expect(AiProfileBodyValidators.clothingSize('x' * 33), isNotNull);
    });

    test('ageYears requires a whole number in range', () {
      expect(AiProfileBodyValidators.ageYears('28'), isNull);
      expect(AiProfileBodyValidators.ageYears('0'), isNotNull);
      expect(AiProfileBodyValidators.ageYears('121'), isNotNull);
      expect(AiProfileBodyValidators.ageYears('28.5'), isNotNull);
    });
  });

  test('parseForm maps filled fields onto WARDROBE-80 names', () {
    final parsed = AiProfileBodyValidators.parseForm(
      heightCm: '170',
      weightKg: '65',
      bustCm: '90.5',
      hipsCm: '100',
      clothingSize: ' M ',
      ageYears: '28',
      bodyType: 'AVERAGE',
      gender: 'FEMALE',
    );

    expect(parsed.heightCm, 170);
    expect(parsed.weightKg, 65);
    expect(parsed.bustCm, 90.5);
    expect(parsed.hipsCm, 100);
    expect(parsed.clothingSize, 'M');
    expect(parsed.ageYears, 28);
    expect(parsed.bodyType, 'AVERAGE');
    expect(parsed.gender, 'FEMALE');
    expect(parsed.isEmpty, isFalse);
  });

  test('summary lists filled fields only', () {
    expect(AiProfileBodyContext.empty.summary, isNull);
    expect(
      const AiProfileBodyContext(heightCm: 170, clothingSize: 'M').summary,
      '170 cm · size M',
    );
  });
}
