import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../providers/garden_provider.dart';
import '../widgets/plant_card.dart';
import '../widgets/add_edit_plant_dialog.dart';
import '../../domain/entities/plant.dart';

class PlantListPage extends StatefulWidget {
  final String gardenId;
  final String gardenName;

  const PlantListPage({
    super.key,
    required this.gardenId,
    required this.gardenName,
  });

  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage> {
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<GardenProvider>().loadPlants(widget.gardenId);
      if (mounted) setState(() => _initialLoading = false);
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddEditPlantDialog(
        onSave: (name, species, date, notes) {
          context.read<GardenProvider>().addPlant(
            gardenId: widget.gardenId,
            name: name,
            species: species,
            plantingDate: date,
            notes: notes,
          );
        },
      ),
    );
  }

  void _showEditDialog(Plant plant) {
    showDialog(
      context: context,
      builder: (_) => AddEditPlantDialog(
        plant: plant,
        onSave: (name, species, date, notes) {
          final updated = Plant(
            id: plant.id,
            gardenId: plant.gardenId,
            name: name,
            species: species,
            plantingDate: date,
            notes: notes,
            createdAt: plant.createdAt,
            updatedAt: DateTime.now(),
          );
          context.read<GardenProvider>().editPlant(updated);
        },
      ),
    );
  }

  void _confirmDelete(Plant plant) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa cây'),
        content: Text('Bạn có chắc muốn xóa "${plant.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GardenProvider>().removePlant(
                plant.id,
                widget.gardenId,
              );
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Cây trồng - ${widget.gardenName}')),
        body: const LoadingIndicator(),
      );
    }

    final provider = context.watch<GardenProvider>();
    final plants = provider.plantsForGarden(widget.gardenId);

    return Scaffold(
      appBar: AppBar(title: Text('Cây trồng - ${widget.gardenName}')),
      body: plants.isEmpty
          ? EmptyStateWidget(
              icon: Icons.eco,
              message: 'Chưa có cây trồng nào',
              actionLabel: 'Thêm cây',
              onAction: _showAddDialog,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plants.length,
              itemBuilder: (_, index) {
                final plant = plants[index];
                return PlantCard(
                  plant: plant,
                  onEdit: () => _showEditDialog(plant),
                  onDelete: () => _confirmDelete(plant),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Thêm cây'),
      ),
    );
  }
}
