/// Optional clothing-item acquired / purchased date (WARDROBE-93).
///
/// Backend contract ([WARDROBE-92](https://tundetunde000.atlassian.net/browse/WARDROBE-92),
/// wardrobe-backend#45 merged main `f8f6ded`): wire field `acquiredAt` as ISO
/// date `YYYY-MM-DD`. Responses omit the field when unset (never JSON `null`).
/// Flutter also accepts an ISO datetime on **read** and keeps the calendar
/// date. Blank / null / unparseable values are treated as unset so list/get
/// stay usable when the field is absent. Writes send `YYYY-MM-DD` only.
abstract final class ItemAcquiredAt {
  static final _ymd = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');

  /// Calendar date in UTC, or `null` when [raw] is empty / invalid.
  static DateTime? tryParse(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is DateTime) {
      return dateOnly(raw);
    }
    if (raw is! String) {
      return null;
    }
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final match = _ymd.firstMatch(trimmed);
    if (match == null) {
      return null;
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final parsed = DateTime.utc(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }
    return parsed;
  }

  /// `YYYY-MM-DD`, or `null` when [date] is unset.
  static String? toWire(DateTime? date) {
    if (date == null) {
      return null;
    }
    final normalized = dateOnly(date);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static DateTime? dateOnlyOrNull(DateTime? date) =>
      date == null ? null : dateOnly(date);

  static String formatDisplay(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final normalized = dateOnly(date);
    return '${normalized.day} ${months[normalized.month - 1]} ${normalized.year}';
  }
}
