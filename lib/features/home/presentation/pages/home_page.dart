import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../../shared/pages/placeholder_pages.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../garden/presentation/pages/garden_page.dart';
import '../providers/home_provider.dart';
import 'more_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(),
      child: const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  final GlobalKey _gnavKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  final List<Map<String, dynamic>> _moreMenuItems = const [
    {'icon': Icons.set_meal_rounded, 'title': 'Vật nuôi', 'color': Color(0xFFFF9800)},
    {'icon': Icons.warehouse_rounded, 'title': 'Kho hàng', 'color': Color(0xFF795548)},
    {'icon': Icons.bar_chart_rounded, 'title': 'Báo cáo', 'color': Color(0xFF00BCD4)},
    {'icon': Icons.notifications_rounded, 'title': 'Thông báo', 'color': Color(0xFFFF5252)},
    {'icon': Icons.settings_rounded, 'title': 'Cài đặt', 'color': Color(0xFF607D8B)},
  ];

  final List<Map<String, dynamic>> _navTabs = const [
    {'icon': Icons.grid_view_rounded, 'text': 'Home', 'color': Color(0xFF1E88E5)},
    {'icon': Icons.yard_rounded, 'text': 'Garden', 'color': Color(0xFF4CAF50)},
    {'icon': Icons.eco_rounded, 'text': 'Plant', 'color': Color(0xFF009688)},
    {'icon': Icons.task_alt_rounded, 'text': 'Tasks', 'color': Color(0xFFFFB300)},
    {'icon': Icons.more_horiz_rounded, 'text': 'More', 'color': Color(0xFF7C4DFF)},
  ];

  void _hideMoreMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void _showMoreMenu(BuildContext context, HomeProvider provider) {
  _hideMoreMenu();

  final RenderBox? renderBox =
      _gnavKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final offset = renderBox.localToGlobal(Offset.zero);
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  _overlayEntry = OverlayEntry(
    builder: (overlayContext) => Positioned(
      right: 16,
      bottom: (MediaQuery.of(context).size.height - offset.dy) + 12,
      width: 190,
      // TapRegion giúp phát hiện khi chạm ra NGOÀI Menu mà KHÔNG nuốt sự kiện bấm
      child: TapRegion(
        onTapOutside: (event) {
          _hideMoreMenu();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              elevation: 12,
              shadowColor: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              color: isDark
                  ? const Color(0xFF1E1E2C).withOpacity(0.9)
                  : Colors.white.withOpacity(0.92),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.12)
                        : Colors.grey.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        _hideMoreMenu();
                        provider.changeTab(4);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor:
                                  const Color(0xFF7C4DFF).withOpacity(0.15),
                              child: const Icon(Icons.widgets_rounded,
                                  size: 16, color: Color(0xFF7C4DFF)),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Tất cả danh mục',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C4DFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                        height: 12,
                        thickness: 0.8,
                        color: isDark ? Colors.white12 : Colors.grey[300]),
                    ..._moreMenuItems.map((item) {
                      final Color itemColor = item['color'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: InkWell(
                          onTap: () {
                            _hideMoreMenu();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Mở ${item['title']}'),
                                backgroundColor: itemColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: itemColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item['icon'],
                                    size: 16,
                                    color: itemColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(_overlayEntry!);
}

  @override
  void dispose() {
    _hideMoreMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final currentIndex = provider.currentIndex;

    final List<Widget> pages = [
      const DashboardPage(),
      const GardenPage(),
      const PlaceholderPage(icon: Icons.eco, title: 'Plant'),
      const PlaceholderPage(icon: Icons.task_alt, title: 'Tasks'),
      const MorePage(),
    ];

    final titles = ['Dashboard', 'Quản lý vườn', 'Plant', 'Tasks', 'More'];
    final activeTabColor = _navTabs[currentIndex]['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          titles[currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng đang phát triển')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển')),
                );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person_rounded, size: 20, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
          top: 8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              spreadRadius: 2,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: GNav(
            key: _gnavKey,
            rippleColor: activeTabColor.withOpacity(0.15),
            hoverColor: activeTabColor.withOpacity(0.05),
            gap: 6,
            activeColor: activeTabColor,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            duration: const Duration(milliseconds: 300),
            color: Colors.grey[500],
            selectedIndex: currentIndex,
            onTabChange: (index) {
              // Dọn dẹp Overlay trước khi thực hiện chuyển tab
              _hideMoreMenu();
              provider.changeTab(index);

              // Chỉ mở lại Menu khi thực sự bấm vào nút More
              if (index == 4) {
                _showMoreMenu(context, provider);
              }
            },
            tabs: _navTabs.map((tab) {
              final Color tabColor = tab['color'];
              return GButton(
                icon: tab['icon'],
                text: tab['text'],
                iconActiveColor: tabColor,
                textColor: tabColor,
                borderRadius: BorderRadius.circular(20),
                backgroundGradient: LinearGradient(
                  colors: [
                    tabColor.withOpacity(0.18),
                    tabColor.withOpacity(0.06),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}