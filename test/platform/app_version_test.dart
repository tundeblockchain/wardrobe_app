import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pubspec version is 1.0.1+2 (versionName 1.0.1, versionCode 2)', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(
      r'^version:\s*(.+)$',
      multiLine: true,
    ).firstMatch(pubspec);

    expect(match, isNotNull, reason: 'pubspec.yaml must declare version:');
    expect(match!.group(1)!.trim(), '1.0.1+2');
    expect(pubspec, isNot(contains(RegExp(r'^version:\s*1\.0\.0\+1\s*$'))));
  });
}
