import 'package:flutter/material.dart';
import '../../../../shared/pages/placeholder_pages.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoreItem(Icons.person, 'Profile', () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PlaceholderPage(
            icon: Icons.person,
            title: 'Profile',
          ),
        ));
      }),
      _MoreItem(Icons.settings, 'Settings', () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PlaceholderPage(
            icon: Icons.settings,
            title: 'Settings',
          ),
        ));
      }),
      _MoreItem(Icons.cloud, 'Weather', () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PlaceholderPage(
            icon: Icons.cloud,
            title: 'Weather',
          ),
        ));
      }),
      _MoreItem(Icons.event, 'Events', () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PlaceholderPage(
            icon: Icons.event,
            title: 'Events',
          ),
        ));
      }),
      _MoreItem(Icons.info_outline, 'About', () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PlaceholderPage(
            icon: Icons.info_outline,
            title: 'About',
          ),
        ));
      }),
      _MoreItem(Icons.help_outline, 'Help', () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PlaceholderPage(
            icon: Icons.help_outline,
            title: 'Help',
          ),
        ));
      }),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
          title: Text(item.title),
          onTap: item.onTap,
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  _MoreItem(this.icon, this.title, this.onTap);
}