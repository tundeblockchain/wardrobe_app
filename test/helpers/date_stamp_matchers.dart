import 'package:flutter_test/flutter_test.dart';

/// Asserts Created/Updated/Added (and formatted date) stamps are hidden.
void expectNoCreatedUpdatedDateStamps() {
  expect(find.textContaining('Created'), findsNothing);
  expect(find.textContaining('Updated'), findsNothing);
  expect(find.textContaining('Added'), findsNothing);
  expect(find.textContaining(RegExp(r'\d{4}-\d{2}-\d{2}')), findsNothing);
}
