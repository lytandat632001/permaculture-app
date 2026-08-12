import 'package:flutter/material.dart';
import '../../domain/entities/garden.dart';
import '../../domain/entities/garden_type_utils.dart';

class GardenDetailPage extends StatelessWidget {
  final Garden garden;

  const GardenDetailPage({super.key, required this.garden});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(garden.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Mở dialog sửa vườn (có thể tái sử dụng AddEditGardenDialog)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.yard, size: 48, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(garden.name, style: textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text(gardenTypeName(garden.type), style: textTheme.titleMedium),
                          if (garden.area != null)
                            Text('Diện tích: ${garden.area!.toStringAsFixed(0)} m²', style: textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Ghi chú
            if (garden.note != null && garden.note!.isNotEmpty) ...[
              Text('Ghi chú', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(garden.note!, style: textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Placeholder cho các module tương lai
            Text('Quản lý', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.eco),
                    title: const Text('Cây trồng'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Mở Plant list
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.checklist),
                    title: const Text('Công việc'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Mở Task list
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Sự kiện'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Mở Event list
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.sensors),
                    title: const Text('Cảm biến'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Mở Sensor list
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.precision_manufacturing),
                    title: const Text('Thiết bị'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Mở Device list
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}