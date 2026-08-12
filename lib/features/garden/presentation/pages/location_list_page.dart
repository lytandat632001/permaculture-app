import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permaculture_application/features/garden/domain/entities/location.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../data/datasources/garden_remote_datasource.dart';
import '../../data/repositories/garden_repository_impl.dart';
import '../../domain/usecases/get_locations.dart';
import '../../domain/usecases/create_location.dart';
import '../../domain/usecases/update_location.dart';
import '../../domain/usecases/delete_location.dart';
import '../../domain/usecases/get_gardens_by_location.dart';
import '../../domain/usecases/create_garden.dart';
import '../../domain/usecases/update_garden.dart';
import '../../domain/usecases/delete_garden.dart';
import '../../domain/usecases/get_plants.dart'; // thêm
import '../../domain/usecases/create_plant.dart'; // thêm
import '../../domain/usecases/update_plant.dart'; // thêm
import '../../domain/usecases/delete_plant.dart'; // thêm
import '../providers/garden_provider.dart';
import '../widgets/location_card.dart';
import '../widgets/add_edit_location_dialog.dart';
import 'location_detail_page.dart';

class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GardenProvider>(
      create: (_) {
        final firestore = FirebaseFirestore.instance;
        final datasource = GardenRemoteDatasource(firestore);
        final repo = GardenRepositoryImpl(datasource);
        return GardenProvider(
          getLocations: GetLocations(repo),
          createLocation: CreateLocation(repo),
          updateLocation: UpdateLocation(repo),
          deleteLocation: DeleteLocation(repo),
          getGardensByLocation: GetGardensByLocation(repo),
          createGarden: CreateGarden(repo),
          updateGarden: UpdateGarden(repo),
          deleteGarden: DeleteGarden(repo),
          getPlants: GetPlants(repo), // thêm
          createPlant: CreatePlant(repo), // thêm
          updatePlant: UpdatePlant(repo), // thêm
          deletePlant: DeletePlant(repo), // thêm
        );
      },
      child: const _LocationListBody(),
    );
  }
}

class _LocationListBody extends StatefulWidget {
  const _LocationListBody();

  @override
  State<_LocationListBody> createState() => _LocationListBodyState();
}

class _LocationListBodyState extends State<_LocationListBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GardenProvider>().loadLocations();
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AddEditLocationDialog(
        onSave: (name, address, lat, lng, note) {
          context.read<GardenProvider>().addLocation(
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            note: note,
          );
        },
      ),
    );
  }

  void _showEditDialog(Location loc) {
    showDialog(
      context: context,
      builder: (_) => AddEditLocationDialog(
        location: loc,
        onSave: (name, address, lat, lng, note) {
          final updated = Location(
            id: loc.id,
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            note: note,
            createdAt: loc.createdAt,
            updatedAt: DateTime.now(),
          );
          context.read<GardenProvider>().editLocation(updated);
        },
      ),
    );
  }

  void _confirmDelete(Location loc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa vị trí'),
        content: Text('Bạn có chắc muốn xóa "${loc.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GardenProvider>().removeLocation(loc.id);
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

    return Scaffold(
      appBar: AppBar(title: const Text('Khu vườn')),
      body: _buildBody(provider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Thêm vị trí'),
      ),
    );
  }

  Widget _buildBody(GardenProvider provider) {
    if (provider.isLoadingLocations) {
      return const LoadingIndicator(message: 'Đang tải...');
    }
    if (provider.error != null && provider.locations.isEmpty) {
      return ErrorStateWidget(
        message: provider.error!,
        onRetry: provider.loadLocations,
      );
    }
    if (provider.locations.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.map_outlined,
        message: 'Chưa có vị trí nào',
        actionLabel: 'Thêm vị trí',
        onAction: _showAddDialog,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.locations.length,
      itemBuilder: (_, index) {
        final loc = provider.locations[index];
        return LocationCard(
          location: loc,
          onTap: () {
            // Điều hướng đến màn hình LocationDetailPage
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LocationDetailPage(location: loc),
              ),
            );
          },
          onEdit: () => _showEditDialog(loc),
          onDelete: () => _confirmDelete(loc),
        );
      },
    );
  }
}
