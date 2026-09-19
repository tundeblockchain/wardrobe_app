/// Calendar date helpers for the worn-on log (WARDROBE-121).
///
/// Backend [WARDROBE-120](https://tundetunde000.atlassian.net/browse/WARDROBE-120)
/// (wardrobe-backend#52 SHA `7d24d0e`) stores `wornOn` as `YYYY-MM-DD` only.
/// Writes never send a datetime. Reads accept a date or an ISO datetime and
/// keep the calendar day. Impossible calendars are rejected.
abstract final class WornOnDate {
  static final _ymd = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  static final _ymdPrefix = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');

  /// Local calendar "today" as a UTC date-only value.
  static DateTime todayLocal([DateTime? now]) {
    final clock = now ?? DateTime.now();
    return DateTime.utc(clock.year, clock.month, clock.day);
  }

  static DateTime dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static DateTime? dateOnlyOrNull(DateTime? date) =>
      date == null ? null : dateOnly(date);

  /// `YYYY-MM-DD` only. Datetimes are ignored so writes stay date-only.
  static String? toWire(DateTime? date) {
    if (date == null) {
      return null;
    }
    return formatWire(dateOnly(date));
  }

  static String formatWire(DateTime date) {
    final normalized = dateOnly(date);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Calendar date in UTC, or `null` when [raw] is empty / invalid.
  ///
  /// Writes must be `YYYY-MM-DD`. Reads also accept an ISO datetime and keep
  /// the leading calendar day so a stray timestamp cannot drop the row.
  static DateTime? tryParse(Object? raw, {bool allowDateTime = true}) {
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
    final match = allowDateTime
        ? _ymdPrefix.firstMatch(trimmed)
        : _ymd.firstMatch(trimmed);
    if (match == null) {
      return null;
    }
    if (!allowDateTime && match.end != trimmed.length) {
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

  /// Strict `YYYY-MM-DD` used for POST / DELETE / query params.
  static DateTime? tryParseStrict(Object? raw) =>
      tryParse(raw, allowDateTime: false);

  static bool isSameDay(DateTime left, DateTime right) =>
      dateOnly(left) == dateOnly(right);

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

  static String formatMonth(DateTime month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final normalized = DateTime.utc(month.year, month.month, 1);
    return '${months[normalized.month - 1]} ${normalized.year}';
  }

  static DateTime monthOf(DateTime date) =>
      DateTime.utc(date.year, date.month, 1);

  static DateTime addMonths(DateTime month, int delta) =>
      DateTime.utc(month.year, month.month + delta, 1);

  static DateTime lastDayOfMonth(DateTime month) =>
      DateTime.utc(month.year, month.month + 1, 0);

  /// Inclusive month window for `GET .../worn-on?from&to`.
  static ({DateTime from, DateTime to}) monthRange(DateTime month) {
    final start = monthOf(month);
    return (from: start, to: lastDayOfMonth(start));
  }
}
