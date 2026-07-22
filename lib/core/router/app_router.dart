import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'route_names.dart';
import 'auth_notifier.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isLoggedIn = authProvider.isAuthenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash';
      if (!isLoggedIn && !isAuthRoute) {
        return state.namedLocation(RouteNames.login);
      }
      if (isLoggedIn && isAuthRoute) {
        return state.namedLocation(RouteNames.home);
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
