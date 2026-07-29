import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routing/app_routes.dart';
import '../core/theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final index = navigationShell.currentIndex;

    if (width >= 1100) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: width >= 1320,
              backgroundColor: AppColors.forest,
              selectedIndex: index,
              onDestinationSelected: navigationShell.goBranch,
              selectedIconTheme: const IconThemeData(color: AppColors.sand),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              selectedLabelTextStyle: const TextStyle(color: Colors.white),
              unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SotongSaveLive',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI 인생·노후설계',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              destinations: [
                for (final d in AppRoutes.destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SotongSaveLive'),
        actions: [
          IconButton(
            tooltip: '메뉴',
            icon: const Icon(Icons.menu),
            onPressed: () => _openMenu(context),
          ),
        ],
      ),
      body: navigationShell,
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var i = 0; i < AppRoutes.destinations.length; i++)
                ListTile(
                  leading: Icon(AppRoutes.destinations[i].icon),
                  title: Text(AppRoutes.destinations[i].label),
                  selected: i == navigationShell.currentIndex,
                  onTap: () {
                    Navigator.pop(ctx);
                    navigationShell.goBranch(i);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
