import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/apartment/apartment_detail_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../models/apartment.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/intro';
  static const auth = '/auth';
  static const home = '/app';
  static const apartment = '/app/apartment/:id';
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
            final id = state.pathParameters['id']!;
            final apt = ApartmentPreview.demos.firstWhere(
              (a) => a.id == id,
              orElse: () => ApartmentPreview.demos.first,
            );
            return CustomTransitionPage(
              key: state.pageKey,
              child: ApartmentDetailScreen(apartment: apt),
              transitionsBuilder: _sharedAxis,
            );
          },
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
    begin: const Offset(0.05, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
  return FadeTransition(
    opacity: animation,
    child: SlideTransition(position: offset, child: child),
  );
}
