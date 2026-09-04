import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/router/app_routes.dart';
import 'package:wardrobe_app/core/router/auth_redirect.dart';

void main() {
  group('resolveAuthRedirect', () {
    group('unknown (restoring)', () {
      test('stays on splash', () {
        expect(
          resolveAuthRedirect(
            status: AuthStatus.unknown,
            location: AppRoutes.splash,
          ),
          isNull,
        );
      });

      test('sends other locations back to splash', () {
        expect(
          resolveAuthRedirect(
            status: AuthStatus.unknown,
            location: AppRoutes.login,
          ),
          AppRoutes.splash,
        );
        expect(
          resolveAuthRedirect(
            status: AuthStatus.unknown,
            location: AppRoutes.wardrobes,
          ),
          AppRoutes.splash,
        );
      });
    });

    group('unauthenticated', () {
      test('allows public routes', () {
        for (final route in AppRoutes.publicRoutes) {
          expect(
            resolveAuthRedirect(
              status: AuthStatus.unauthenticated,
              location: route,
            ),
            isNull,
            reason: route,
          );
        }
      });

      test('protects authenticated routes', () {
        expect(
          resolveAuthRedirect(
            status: AuthStatus.unauthenticated,
            location: AppRoutes.wardrobes,
          ),
          AppRoutes.login,
        );
        expect(
          resolveAuthRedirect(
            status: AuthStatus.unauthenticated,
            location: AppRoutes.splash,
          ),
          AppRoutes.login,
        );
      });
    });

    group('authenticated', () {
      test('sends splash and public routes to wardrobes', () {
        expect(
          resolveAuthRedirect(
            status: AuthStatus.authenticated,
            location: AppRoutes.splash,
          ),
          AppRoutes.wardrobes,
        );
        expect(
          resolveAuthRedirect(
            status: AuthStatus.authenticated,
            location: AppRoutes.login,
          ),
          AppRoutes.wardrobes,
        );
        expect(
          resolveAuthRedirect(
            status: AuthStatus.authenticated,
            location: AppRoutes.signup,
          ),
          AppRoutes.wardrobes,
        );
        expect(
          resolveAuthRedirect(
            status: AuthStatus.authenticated,
            location: AppRoutes.forgotPassword,
          ),
          AppRoutes.wardrobes,
        );
      });

      test('allows authenticated home', () {
        expect(
          resolveAuthRedirect(
            status: AuthStatus.authenticated,
            location: AppRoutes.wardrobes,
          ),
          isNull,
        );
      });
    });

    test('normalizes trailing slashes', () {
      expect(
        resolveAuthRedirect(
          status: AuthStatus.unauthenticated,
          location: '/login/',
        ),
        isNull,
      );
      expect(
        resolveAuthRedirect(
          status: AuthStatus.unauthenticated,
          location: '/wardrobes/',
        ),
        AppRoutes.login,
      );
    });
  });
}
