import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/share/domain/share_url.dart';

void main() {
  test('resolves landing base + relative sharePath', () {
    expect(
      ShareLandingUrl.resolve(
        landingBaseUrl: 'https://share.example.com',
        sharePath: '/share/shr_abc',
      ),
      'https://share.example.com/share/shr_abc',
    );
  });

  test('strips trailing slashes on the landing base', () {
    expect(
      ShareLandingUrl.resolve(
        landingBaseUrl: 'https://share.example.com/',
        sharePath: '/share/shr_abc',
      ),
      'https://share.example.com/share/shr_abc',
    );
  });

  test('rejects empty or non-http landing bases', () {
    expect(
      ShareLandingUrl.resolve(landingBaseUrl: '', sharePath: '/share/shr_abc'),
      isNull,
    );
    expect(
      ShareLandingUrl.resolve(
        landingBaseUrl: 'ftp://share.example.com',
        sharePath: '/share/shr_abc',
      ),
      isNull,
    );
    expect(ShareLandingUrl.normalizeBase('   '), isNull);
  });

  test('rejects absolute sharePath so the client never double-hosts', () {
    expect(
      ShareLandingUrl.resolve(
        landingBaseUrl: 'https://share.example.com',
        sharePath: 'https://evil.example/share/shr_abc',
      ),
      isNull,
    );
    expect(
      ShareLandingUrl.normalizePath('https://share.example.com/share/x'),
      isNull,
    );
  });

  test('prefixes a missing leading slash on a relative path', () {
    expect(ShareLandingUrl.normalizePath('share/shr_abc'), '/share/shr_abc');
  });
}
