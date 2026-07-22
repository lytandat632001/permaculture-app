import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

/// Cấu hình router cho toàn bộ ứng dụng
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      // Auth
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login')),
        ),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Register')),
        ),
      ),
      // Home shell (sẽ chứa BottomNavigationBar)
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

  /// Tính toán chỉ số tab dựa trên URI
  int _calculateSelectedIndex(Uri uri) {
    if (uri.path.startsWith('/dashboard')) return 0;
    if (uri.path.startsWith('/gardens')) return 1;
    if (uri.path.startsWith('/tasks')) return 2;
    if (uri.path.startsWith('/profile')) return 3;
    return 0;
  }

  /// Xử lý khi người dùng chạm vào tab
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