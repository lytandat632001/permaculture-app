import 'package:flutter/material.dart';
import '../../domain/entities/garden.dart';
import '../../domain/entities/garden_type_utils.dart';
import '../../../../core/extensions/context_extensions.dart';

class GardenCard extends StatelessWidget {
  final Garden garden;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GardenCard({
    super.key,
    required this.garden,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.yard, color: context.colorScheme.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      garden.name,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gardenTypeName(garden.type),
                      style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                    if (garden.area != null)
                      Text(
                        'Diện tích: ${garden.area!.toStringAsFixed(0)} m²',
                        style: context.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  else if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Sửa vườn')),
                  const PopupMenuItem(value: 'delete', child: Text('Xóa vườn')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}