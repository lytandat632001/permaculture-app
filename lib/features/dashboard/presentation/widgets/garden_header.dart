import 'package:flutter/material.dart';
import '../../domain/entities/garden_info.dart';

class GardenHeader extends StatelessWidget {
  final GardenInfo info;

  const GardenHeader({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            info.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60,
              height: 60,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      info.location,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Diện tích: ${info.area.toStringAsFixed(0)} m²',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: info.status == 'active'
                ? Colors.green.shade50
                : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            info.status == 'active' ? 'Hoạt động' : 'Tạm dừng',
            style: TextStyle(
              color: info.status == 'active' ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
