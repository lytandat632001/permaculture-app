import 'package:flutter/material.dart';
import 'package:permaculture_application/features/garden/presentation/pages/garden_detail_page.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/garden.dart';
import '../providers/garden_provider.dart';
import '../widgets/garden_card.dart';
import '../widgets/add_edit_garden_dialog.dart';
import '../widgets/location_weather_tile.dart'; // <-- thêm import

class LocationDetailPage extends StatefulWidget {
  final Location location;

  const LocationDetailPage({super.key, required this.location});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GardenProvider>().loadGardens(widget.location.id);
    });
  }

  void _showAddGardenDialog() {
    showDialog(
      context: context,
      builder: (_) => AddEditGardenDialog(
        onSave: (name, type, area, note) {
          context.read<GardenProvider>().addGarden(
            locationId: widget.location.id,
            name: name,
            type: type,
            area: area,
            note: note,
          );
        },
      ),
    );
  }

  void _showEditGardenDialog(Garden garden) {
    showDialog(
      context: context,
      builder: (_) => AddEditGardenDialog(
        garden: garden,
        onSave: (name, type, area, note) {
          final updated = Garden(
            id: garden.id,
            locationId: garden.locationId,
            name: name,
            type: type,
            area: area,
            note: note,
            createdAt: garden.createdAt,
            updatedAt: DateTime.now(),
          );
          context.read<GardenProvider>().editGarden(updated);
        },
      ),
    );
  }

  void _confirmDeleteGarden(Garden garden) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa vườn'),
        content: Text('Bạn có chắc muốn xóa "${garden.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GardenProvider>().removeGarden(
                garden.id,
                garden.locationId,
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
    final provider = context.watch<GardenProvider>();
    final gardens = provider.gardensForLocation(widget.location.id);

    return Scaffold(
      appBar: AppBar(title: Text(widget.location.name)),
      body: _buildBody(provider, gardens),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGardenDialog,
        icon: const Icon(Icons.add),
        label: const Text('Thêm vườn'),
      ),
    );
  }

  Widget _buildBody(GardenProvider provider, List<Garden> gardens) {
    return Column(
      children: [
        // Header với thông tin vị trí và thời tiết
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.location.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.location.address != null &&
                        widget.location.address!.isNotEmpty)
                      Text(
                        widget.location.address!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              LocationWeatherTile(
                latitude: widget.location.latitude,
                longitude: widget.location.longitude,
              ),
            ],
          ),
        ),
        // Danh sách garden
        Expanded(
          child: provider.isLoadingGardens
              ? const LoadingIndicator(message: 'Đang tải...')
              : gardens.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.yard_outlined,
                  message: 'Chưa có khu vườn nào',
                  actionLabel: 'Thêm vườn',
                  onAction: _showAddGardenDialog,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: gardens.length,
                  itemBuilder: (_, index) {
                    final garden = gardens[index];
                    return GardenCard(
                      garden: garden,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GardenDetailPage(garden: garden),
                          ),
                        );
                      },
                      onEdit: () => _showEditGardenDialog(garden),
                      onDelete: () => _confirmDeleteGarden(garden),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
