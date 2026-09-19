import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Clock for "mark worn today". Tests override with a fixed local date.
final wornOnClockProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});
