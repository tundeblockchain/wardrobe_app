import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/items/presentation/add_item_screen.dart';
import '../../features/items/presentation/edit_item_screen.dart';
import '../../features/items/presentation/item_detail_screen.dart';
import '../../features/outfits/presentation/create_outfit_screen.dart';
import '../../features/outfits/presentation/edit_outfit_screen.dart';
import '../../features/outfits/presentation/outfit_detail_screen.dart';
import '../../features/outfits/presentation/outfits_screen.dart';
import '../../features/wardrobes/presentation/create_wardrobe_screen.dart';
import '../../features/wardrobes/presentation/wardrobe_detail_screen.dart';
import '../../features/wardrobes/presentation/wardrobes_screen.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

/// Notifies go_router when [AuthStatus] changes without recreating the router.
final routerRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.listen(authControllerProvider, (previous, next) {
    if (previous?.status != next.status) {
      notifier.value++;
    }
  });
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Application [GoRouter] with auth redirect.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      return resolveAuthRedirect(
        status: auth.status,
        location: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.wardrobes,
        builder: (context, state) => const WardrobesScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateWardrobeScreen(),
          ),
          GoRoute(
            path: ':wardrobeId',
            builder: (context, state) {
              final wardrobeId = state.pathParameters['wardrobeId']!;
              return WardrobeDetailScreen(wardrobeId: wardrobeId);
            },
            routes: [
              GoRoute(
                path: 'outfits',
                builder: (context, state) {
                  final wardrobeId = state.pathParameters['wardrobeId']!;
                  return OutfitsScreen(wardrobeId: wardrobeId);
                },
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) {
                      final wardrobeId = state.pathParameters['wardrobeId']!;
                      return CreateOutfitScreen(wardrobeId: wardrobeId);
                    },
                  ),
                  GoRoute(
                    path: ':outfitId',
                    builder: (context, state) {
                      final wardrobeId = state.pathParameters['wardrobeId']!;
                      final outfitId = state.pathParameters['outfitId']!;
                      return OutfitDetailScreen(
                        wardrobeId: wardrobeId,
                        outfitId: outfitId,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final wardrobeId =
                              state.pathParameters['wardrobeId']!;
                          final outfitId = state.pathParameters['outfitId']!;
                          return EditOutfitScreen(
                            wardrobeId: wardrobeId,
                            outfitId: outfitId,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'items/create',
                builder: (context, state) {
                  final wardrobeId = state.pathParameters['wardrobeId']!;
                  return AddItemScreen(wardrobeId: wardrobeId);
                },
              ),
              GoRoute(
                path: 'items/:itemId',
                builder: (context, state) {
                  final wardrobeId = state.pathParameters['wardrobeId']!;
                  final itemId = state.pathParameters['itemId']!;
                  return ItemDetailScreen(
                    wardrobeId: wardrobeId,
                    itemId: itemId,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final wardrobeId = state.pathParameters['wardrobeId']!;
                      final itemId = state.pathParameters['itemId']!;
                      return EditItemScreen(
                        wardrobeId: wardrobeId,
                        itemId: itemId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
