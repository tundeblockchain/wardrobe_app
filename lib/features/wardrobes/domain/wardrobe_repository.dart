import 'wardrobe.dart';

/// Wardrobe CRUD contract. Implementations talk to the HTTP API.
abstract interface class WardrobeRepository {
  Future<List<Wardrobe>> listWardrobes();

  Future<Wardrobe> getWardrobe(String id);

  Future<Wardrobe> createWardrobe({required String name});

  Future<Wardrobe> updateWardrobe({required String id, required String name});

  Future<void> deleteWardrobe(String id);
}
