import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/pages/placeholder_pages.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../providers/home_provider.dart';
import 'more_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(),
      child: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatelessWidget {
  const _HomeShell();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final currentIndex = provider.currentIndex;

    final List<Widget> pages = [
      const DashboardPage(),
      const PlaceholderPage(icon: Icons.yard, title: 'Garden'),
      const PlaceholderPage(icon: Icons.eco, title: 'Plant'),
      const PlaceholderPage(icon: Icons.task_alt, title: 'Tasks'),
      const MorePage(),
    ];

    final titles = ['Dashboard', 'Garden', 'Plant', 'Tasks', 'More'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng đang phát triển')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển')),
                );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: provider.changeTab,
        animationDuration: const Duration(milliseconds: 300),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.yard_outlined),
            selectedIcon: Icon(Icons.yard),
            label: 'Garden',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco),
            label: 'Plant',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
