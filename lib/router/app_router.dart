import 'dart:async';

import 'package:coach_e/core/auth/auth_cubit.dart';
import 'package:coach_e/features/coaching/coaching_page.dart';
import 'package:coach_e/features/home/home_page.dart';
import 'package:coach_e/features/login/login_page.dart';
import 'package:coach_e/features/splash/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const coaching = '/coaching';
}

GoRouter createAppRouter({
  required AuthCubit authCubit,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authStatus = authCubit.state.status;
      final location = state.matchedLocation;
      final isAuthRoute = location == AppRoutes.login;
      final isSplash = location == AppRoutes.splash;

      if (authStatus == AuthStatus.checking) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      if (isSplash || isAuthRoute) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.coaching,
        builder: (context, state) => const CoachingPage(),
      ),
    ],
  );
}

class AppRouterRefreshStream extends ChangeNotifier {
  AppRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
