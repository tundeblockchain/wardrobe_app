/// String utility functions for the Wardrobe app.
///
/// This module provides common string manipulation utilities used throughout
/// the application, such as formatting clothing item names, validating input,
/// and text transformations.
library;

/// Capitalizes the first letter of a string.
///
/// Returns an empty string if the input is empty.
/// Example: "shirt" -> "Shirt"
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

/// Converts a string to title case (each word capitalized).
///
/// Example: "blue denim jacket" -> "Blue Denim Jacket"
String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) => capitalize(word)).join(' ');
}

/// Truncates a string to a maximum length, adding an ellipsis if truncated.
///
/// If the string is shorter than or equal to [maxLength], it is returned as-is.
/// Otherwise, it is truncated and "..." is appended.
///
/// The [maxLength] must be at least 4 to accommodate the ellipsis.
String truncate(String text, int maxLength) {
  if (maxLength < 4) {
    throw ArgumentError('maxLength must be at least 4');
  }
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength - 3)}...';
}

/// Checks if a string is a valid item name.
///
/// A valid item name:
/// - Is not empty or whitespace-only
/// - Has at least 2 characters after trimming
/// - Contains only letters, numbers, spaces, and hyphens
bool isValidItemName(String name) {
  final trimmed = name.trim();
  if (trimmed.length < 2) return false;
  return RegExp(r'^[a-zA-Z0-9\s\-]+$').hasMatch(trimmed);
}

/// Generates a URL-safe slug from a string.
///
/// Converts to lowercase, replaces spaces with hyphens, removes invalid
/// characters, and collapses multiple hyphens.
///
/// Example: "Blue Denim Jacket!" -> "blue-denim-jacket"
String toSlug(String text) {
  return text
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-');
}
