/// Optional auto-open on the add-item screen (empty-state convert CTAs).
enum AddItemInitialPick {
  gallery,
  camera;

  static AddItemInitialPick? tryParse(String? value) {
    return switch (value) {
      'gallery' => AddItemInitialPick.gallery,
      'camera' => AddItemInitialPick.camera,
      _ => null,
    };
  }
}
