import 'package:flutter/material.dart';

/// Shared spacing scale used by the theme and empty / error surfaces.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  /// Default [ListView] / form padding.
  static const page = lg;

  static const pageInsets = EdgeInsets.all(page);
}

/// Corner radii for cards, buttons, inputs, and dialogs.
abstract final class AppRadii {
  static const sm = 12.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const pill = 999.0;

  static const card = BorderRadius.all(Radius.circular(lg));
  static const button = BorderRadius.all(Radius.circular(md));
  static const input = BorderRadius.all(Radius.circular(md));
  static const dialog = BorderRadius.all(Radius.circular(xl));
  static const chip = BorderRadius.all(Radius.circular(lg));
  static const fab = BorderRadius.all(Radius.circular(md));
}
