import 'package:flutter/material.dart';
import '../../domain/entities/garden_dashboard.dart';
import 'garden_dashboard_card.dart';

class GardenDashboardList extends StatelessWidget {
  final List<GardenDashboard> gardens;

  const GardenDashboardList({super.key, required this.gardens});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => GardenDashboardCard(garden: gardens[index]),
        childCount: gardens.length,
      ),
    );
  }
}
