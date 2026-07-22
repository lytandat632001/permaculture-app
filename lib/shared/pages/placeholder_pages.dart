import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? child; // cho phép thêm nội dung tùy chỉnh (dùng cho More)

  const PlaceholderPage({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle = 'Tính năng đang được phát triển',
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (child != null) ...[
              const SizedBox(height: 24),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}