import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../data/datasources/dashboard_local_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_gardens_dashboard.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/garden_dashboard_list.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardProvider>(
      create: (_) {
        final datasource = DashboardLocalDatasource();
        final repo = DashboardRepositoryImpl(datasource);
        final usecase = GetGardensDashboard(repo);
        return DashboardProvider(usecase);
      },
      // child: Text("Tab Dashboard đang hoạt động"),
      child: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    if (provider.isLoading) {
      return const LoadingIndicator(message: 'Đang tải dữ liệu...');
    }

    if (provider.error != null) {
      return ErrorStateWidget(
        message: provider.error!,
        onRetry: provider.refresh,
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: DashboardHeader(
              userName: 'Chủ vườn',
              gardenCount: provider.gardenCount,
              alertCount: provider.totalAlerts,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          GardenDashboardList(gardens: provider.gardens),
        ],
      ),
    );
  }
}
