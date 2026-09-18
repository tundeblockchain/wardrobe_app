import 'package:flutter/material.dart';

/// First-visit coach-mark screens (WARDROBE-99). Device-scoped, not account data.
enum CoachScreen { home, wardrobe, outfit, item, tryOn, profile }

/// Short instructional copy for a [CoachScreen].
class CoachCopy {
  const CoachCopy({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  static const home = CoachCopy(
    title: 'Your wardrobes',
    body:
        'This is home. Open a wardrobe to manage items and outfits, or tap + '
        'to start a new closet. Related shopping finds sit below the carousel.',
    icon: Icons.checkroom_outlined,
  );

  static const wardrobe = CoachCopy(
    title: 'Inside a wardrobe',
    body:
        'Swipe clothing cards, filter by type, and jump to outfits, '
        'suggestions, or the dressing room. Tap + to photograph a new piece.',
    icon: Icons.style_outlined,
  );

  static const outfit = CoachCopy(
    title: 'Build looks',
    body:
        'Combine items into outfits. Create a look with the hanger button, or '
        'open the dressing room and suggestions from the header.',
    icon: Icons.dry_cleaning_outlined,
  );

  static const item = CoachCopy(
    title: 'Item details',
    body:
        'Review the photo, edit details, and see which outfits include this '
        'piece. Related shopping links appear below when they are available.',
    icon: Icons.inventory_2_outlined,
  );

  static const tryOn = CoachCopy(
    title: 'Virtual try-on',
    body:
        'Pick an outfit and a ready AI profile, then render the look. Saved '
        'results stay on the outfit so you can compare later.',
    icon: Icons.face_retouching_natural_outlined,
  );

  static const profile = CoachCopy(
    title: 'Account and settings',
    body:
        'Switch light or dark theme, manage your plan, set up AI try-on '
        'photos, and reach support from this page.',
    icon: Icons.account_circle_outlined,
  );

  static CoachCopy of(CoachScreen screen) {
    return switch (screen) {
      CoachScreen.home => home,
      CoachScreen.wardrobe => wardrobe,
      CoachScreen.outfit => outfit,
      CoachScreen.item => item,
      CoachScreen.tryOn => tryOn,
      CoachScreen.profile => profile,
    };
  }
}

extension CoachScreenPersistence on CoachScreen {
  /// SharedPreferences key. Device-scoped like theme mode (WARDROBE-70).
  String get preferenceKey => 'coach_seen_$name';
}
