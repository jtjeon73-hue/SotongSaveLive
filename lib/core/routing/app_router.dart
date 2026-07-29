import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/five_lives/five_lives_page.dart';
import '../../features/five_lives/life_type_detail_page.dart';
import '../../features/health_life/health_life_page.dart';
import '../../features/home/home_page.dart';
import '../../features/legacy/legacy_page.dart';
import '../../features/money_work/money_work_page.dart';
import '../../features/roadmap/roadmap_page.dart';
import '../../features/rural_life/rural_life_page.dart';
import '../../services/life_scenario_repository.dart';
import 'app_routes.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.fiveLives,
                builder: (context, state) => const FiveLivesPage(),
                routes: [
                  GoRoute(
                    path: ':type',
                    builder: (context, state) {
                      final slug = state.pathParameters['type'] ?? '';
                      final profile = LifeScenarioRepository().bySlug(slug);
                      if (profile == null) {
                        return const _NotFoundBody();
                      }
                      return LifeTypeDetailPage(profile: profile);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.roadmap,
                builder: (context, state) => const RoadmapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.moneyWork,
                builder: (context, state) => const MoneyWorkPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.healthLife,
                builder: (context, state) => const HealthLifePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.rural,
                builder: (context, state) => const RuralLifePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.legacy,
                builder: (context, state) => const LegacyPage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('페이지를 찾을 수 없습니다')),
      body: const _NotFoundBody(),
    ),
  );
}

class _NotFoundBody extends StatelessWidget {
  const _NotFoundBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('요청하신 페이지를 찾을 수 없습니다.'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('홈으로'),
          ),
        ],
      ),
    );
  }
}
