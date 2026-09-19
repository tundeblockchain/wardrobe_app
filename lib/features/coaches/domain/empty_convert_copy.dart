/// Short empty-state convert copy for Home / Wardrobe (WARDROBE-113).
///
/// Complements first-visit coach marks (WARDROBE-99). This is a CTA card, not
/// a long tutorial.
abstract final class EmptyConvertCopy {
  static const homeTitle = 'Start your first wardrobe';
  static const homeBody =
      'A wardrobe holds your clothes and outfits. Create one, then add photos '
      'from the gallery.';
  static const homeAction = 'Create wardrobe';

  static const wardrobeTitle = 'Add your first piece';
  static const wardrobeBody =
      'Pick several photos from your gallery, or take one now.';
  static const wardrobePrimary = 'Add from gallery';
  static const wardrobeSecondary = 'Take a photo';
}
