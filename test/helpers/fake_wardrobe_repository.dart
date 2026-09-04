import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/wardrobes/domain/wardrobe.dart';
import 'package:wardrobe_app/features/wardrobes/domain/wardrobe_repository.dart';

/// In-memory [WardrobeRepository] for unit and widget tests.
class FakeWardrobeRepository implements WardrobeRepository {
  FakeWardrobeRepository({List<Wardrobe>? seed}) : items = [...?seed];

  final List<Wardrobe> items;
  ApiException? nextFailure;
  int listCalls = 0;
  int getCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;

  @override
  Future<List<Wardrobe>> listWardrobes() async {
    listCalls++;
    _maybeFail();
    return [...items];
  }

  @override
  Future<Wardrobe> getWardrobe(String id) async {
    getCalls++;
    _maybeFail();
    return items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException(
        message: 'Wardrobe not found.',
        code: 'WARDROBE_NOT_FOUND',
        statusCode: 404,
      ),
    );
  }

  @override
  Future<Wardrobe> createWardrobe({required String name}) async {
    createCalls++;
    _maybeFail();
    final now = DateTime.utc(2026, 9, 4, 12);
    final wardrobe = Wardrobe(
      id: 'wd_${items.length + 1}',
      name: name,
      createdAt: now,
      updatedAt: now,
    );
    items.add(wardrobe);
    return wardrobe;
  }

  @override
  Future<Wardrobe> updateWardrobe({
    required String id,
    required String name,
  }) async {
    updateCalls++;
    _maybeFail();
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw const ApiException(
        message: 'Wardrobe not found.',
        code: 'WARDROBE_NOT_FOUND',
        statusCode: 404,
      );
    }
    final updated = items[index].copyWith(
      name: name,
      updatedAt: DateTime.utc(2026, 9, 4, 13),
    );
    items[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteWardrobe(String id) async {
    deleteCalls++;
    _maybeFail();
    items.removeWhere((item) => item.id == id);
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

Wardrobe testWardrobe({
  String id = 'wd_abc123',
  String name = 'Summer Clothes',
}) {
  return Wardrobe(
    id: id,
    name: name,
    createdAt: DateTime.utc(2026, 9, 3, 18, 35),
    updatedAt: DateTime.utc(2026, 9, 3, 18, 35),
  );
}
