import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'route_names.dart';
import 'auth_notifier.dart';
import '../../features/auth/presentation/providers/auth_provider.dart'; // không hide
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isLoggedIn = authProvider.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash';
      if (!isLoggedIn && !isAuthRoute) {
        return state.namedLocation(RouteNames.login);
      }
      if (isLoggedIn && isAuthRoute) {
        return state.namedLocation(RouteNames.dashboard);
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
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(state.uri),
            onTap: (index) => _onTabTapped(context, index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.yard), label: 'Garden'),
              BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tasks'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: RouteNames.dashboard,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Dashboard')),
            ),
          ),
          GoRoute(
            path: '/gardens',
            name: RouteNames.gardenList,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Gardens')),
            ),
          ),
          GoRoute(
            path: '/tasks',
            name: RouteNames.taskList,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Tasks')),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Profile')),
            ),
          ),
        ],
      ),
    ],
  );

  int _calculateSelectedIndex(Uri uri) {
    if (uri.path.startsWith('/dashboard')) return 0;
    if (uri.path.startsWith('/gardens')) return 1;
    if (uri.path.startsWith('/tasks')) return 2;
    if (uri.path.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.dashboard);
      case 1:
        context.goNamed(RouteNames.gardenList);
      case 2:
        context.goNamed(RouteNames.taskList);
      case 3:
        context.goNamed(RouteNames.profile);
    }
  }
}