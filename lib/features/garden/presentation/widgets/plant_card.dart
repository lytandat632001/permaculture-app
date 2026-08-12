import 'package:flutter/material.dart';
import '../../domain/entities/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.eco, color: Colors.green),
        title: Text(plant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plant.species != null) Text(plant.species!),
            if (plant.plantingDate != null)
              Text('Trồng: ${plant.plantingDate!.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            else if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Sửa')),
            const PopupMenuItem(value: 'delete', child: Text('Xóa')),
          ],
        ),
      ),
    );
  }
}