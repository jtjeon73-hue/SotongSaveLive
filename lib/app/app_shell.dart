import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../services/crisis_session_controller.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
    required this.controller,
  });

  final StatefulNavigationShell navigationShell;
  final CrisisSessionController controller;

  static const _destinations = [
    (AppRoutes.home, '홈', Icons.home_outlined),
    (AppRoutes.assess, '상황판단', Icons.health_and_safety_outlined),
    (AppRoutes.witness, '목격자', Icons.group_outlined),
    (AppRoutes.command, '지휘센터', Icons.emergency_outlined),
    (AppRoutes.riskPredict, '위험예측', Icons.radar_outlined),
    (AppRoutes.family, '가족안전', Icons.family_restroom),
    (AppRoutes.industrial, '현장관제', Icons.precision_manufacturing_outlined),
    (AppRoutes.twin, '디지털트윈', Icons.person_outline),
    (AppRoutes.report, '보고서', Icons.description_outlined),
    (AppRoutes.followUp, '추적', Icons.timeline_outlined),
    (AppRoutes.aiLab, '기술연구소', Icons.science_outlined),
    (AppRoutes.trust, '신뢰·출처', Icons.verified_user_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final urgent =
        controller.crisis?.assessment?.level.rank != null &&
        controller.crisis!.assessment!.level.rank >= 4;
    final index = navigationShell.currentIndex;

    if (width >= 1100) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: width >= 1280,
              selectedIndex: index,
              onDestinationSelected: navigationShell.goBranch,
              labelType: width >= 1280
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                child: Column(
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
                      'AI 생명구조',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.$3),
                    label: Text(d.$2),
                  ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  if (controller.storing)
                    const LinearProgressIndicator(minHeight: 2),
                  if (urgent)
                    MaterialBanner(
                      content: const Text('긴급 모드: 지금 해야 할 행동과 구조 연결에 집중하세요.'),
                      backgroundColor: AppColors.danger.withValues(alpha: 0.12),
                      actions: [
                        TextButton(
                          onPressed: () => context.go(AppRoutes.command),
                          child: const Text('지휘센터로'),
                        ),
                      ],
                    ),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SotongSaveLive'),
        actions: [
          if (controller.storing)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          IconButton(
            tooltip: '메뉴',
            onPressed: () => _openMenu(context),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          if (urgent)
            Container(
              width: double.infinity,
              color: AppColors.danger.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(10),
              child: const Text('긴급 모드 · 지휘센터에서 지금 할 일을 확인하세요.'),
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: index > 4
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: navigationShell.goBranch,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: '홈',
                ),
                NavigationDestination(
                  icon: Icon(Icons.health_and_safety_outlined),
                  label: '판단',
                ),
                NavigationDestination(
                  icon: Icon(Icons.group_outlined),
                  label: '목격자',
                ),
                NavigationDestination(
                  icon: Icon(Icons.emergency_outlined),
                  label: '지휘',
                ),
                NavigationDestination(
                  icon: Icon(Icons.radar_outlined),
                  label: '예측',
                ),
              ],
            ),
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return ListView(
          children: [
            for (var i = 0; i < _destinations.length; i++)
              ListTile(
                leading: Icon(_destinations[i].$3),
                title: Text(_destinations[i].$2),
                onTap: () {
                  Navigator.pop(ctx);
                  navigationShell.goBranch(i);
                },
              ),
          ],
        );
      },
    );
  }
}
