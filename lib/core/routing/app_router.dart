import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/apartment/apartment_detail_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/services/screens/compare_screen.dart';
import '../../features/services/screens/docs_screen.dart';
import '../../features/services/screens/favorites_screen.dart';
import '../../features/services/screens/mortgage_screen.dart';
import '../../features/services/screens/profile_screen.dart';
import '../../features/services/screens/stub_service_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../models/apartment.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/intro';
  static const auth = '/auth';
  static const home = '/app';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: _fadeThrough,
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: _sharedAxis,
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AuthScreen(),
        transitionsBuilder: _sharedAxis,
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const MainShell(),
        transitionsBuilder: _fadeThrough,
      ),
      routes: [
        GoRoute(
          path: 'apartment/:id',
          pageBuilder: (context, state) {
            final apt = ApartmentPreview.byId(state.pathParameters['id']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: ApartmentDetailScreen(apartment: apt),
              transitionsBuilder: _sharedAxis,
            );
          },
        ),
        GoRoute(
          path: 'services/mortgage',
          builder: (context, state) => const MortgageScreen(),
        ),
        GoRoute(
          path: 'services/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: 'services/compare',
          builder: (context, state) => const CompareScreen(),
        ),
        GoRoute(
          path: 'services/docs',
          builder: (context, state) => const DocsScreen(),
        ),
        GoRoute(
          path: 'services/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'services/:slug',
          builder: (context, state) => StubServiceScreen(
            slug: state.pathParameters['slug']!,
          ),
        ),
      ],
    ),
  ],
);

Widget _fadeThrough(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
    child: child,
  );
}

Widget _sharedAxis(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final offset = Tween<Offset>(
    begin: const Offset(0.04, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
  return FadeTransition(
    opacity: animation,
    child: SlideTransition(position: offset, child: child),
  );
}
