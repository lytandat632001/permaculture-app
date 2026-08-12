import 'package:flutter/material.dart';
import 'package:permaculture_application/features/garden/presentation/widgets/location_weather_tile.dart';
import '../../domain/entities/location.dart';
import '../../../../core/extensions/context_extensions.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LocationCard({
    super.key,
    required this.location,
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
              Icon(
                Icons.location_on,
                color: context.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (location.address != null &&
                        location.address!.isNotEmpty)
                      Text(
                        location.address!,
                        style: context.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              LocationWeatherTile(
                latitude: location.latitude,
                longitude: location.longitude,
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit')
                    onEdit?.call();
                  else if (value == 'delete')
                    onDelete?.call();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Sửa vị trí')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Xóa vị trí'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
