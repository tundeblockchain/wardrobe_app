import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/wardrobes/data/wardrobe_dtos.dart';

void main() {
  final json = {
    'wardrobeId': 'wd_abc123',
    'name': 'Summer Clothes',
    'createdAt': '2026-09-03T18:35:00Z',
    'updatedAt': '2026-09-03T19:10:00Z',
  };

  group('WardrobeResponse', () {
    test('fromJson maps wardrobeId to domain id', () {
      final domain = WardrobeResponse.fromJson(json).toDomain();

      expect(domain.id, 'wd_abc123');
      expect(domain.name, 'Summer Clothes');
      expect(domain.createdAt.toUtc(), DateTime.utc(2026, 9, 3, 18, 35));
      expect(domain.updatedAt.toUtc(), DateTime.utc(2026, 9, 3, 19, 10));
    });

    test('does not leak wardrobeId onto the domain model', () {
      final domain = WardrobeResponse.fromJson(json).toDomain();
      expect(domain.toString(), isNot(contains('wardrobeId')));
      expect(domain.id, isNotEmpty);
    });
  });

  group('WardrobeListResponse', () {
    test('maps nested wardrobes array to domain list', () {
      final domain = WardrobeListResponse.fromJson({
        'wardrobes': [json],
      }).toDomain();

      expect(domain, hasLength(1));
      expect(domain.single.id, 'wd_abc123');
    });
  });

  group('write request DTOs', () {
    test('create and update serialize name only', () {
      expect(const CreateWardrobeRequest(name: 'Home').toJson(), {
        'name': 'Home',
      });
      expect(const UpdateWardrobeRequest(name: 'Work').toJson(), {
        'name': 'Work',
      });
    });
  });
}
