import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/health_life/health_life_page.dart';
import '../../features/home/home_page.dart';
import '../../features/legacy/legacy_page.dart';
import '../../features/life_paths/life_paths_page.dart';
import '../../features/life_paths/life_type_detail_page.dart';
import '../../features/mind_lounge/mind_essay_page.dart';
import '../../features/mind_lounge/mind_lounge_page.dart';
import '../../features/money_work/money_work_page.dart';
import '../../features/roadmap/roadmap_page.dart';
import '../../features/rural_life/rural_life_page.dart';
import '../../services/life_scenario_repository.dart';
import '../../services/mind_essay_repository.dart';
import 'app_routes.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final loc = state.uri.path;
      if (loc == AppRoutes.fiveLivesLegacy) {
        return AppRoutes.lifePaths;
      }
      if (loc.startsWith('${AppRoutes.fiveLivesLegacy}/')) {
        final slug = loc.substring(AppRoutes.fiveLivesLegacy.length + 1);
        return AppRoutes.lifeDetail(slug);
      }
      return null;
    },
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
                path: AppRoutes.lifePaths,
                builder: (context, state) => const LifePathsPage(),
                routes: [
                  GoRoute(
                    path: ':type',
                    builder: (context, state) {
                      final slug = state.pathParameters['type'] ?? '';
                      final profile = LifeScenarioRepository().bySlug(slug);
                      if (profile == null) {
                        return _MissingLifeType(slug: slug);
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
                path: AppRoutes.mindLounge,
                builder: (context, state) => const MindLoungePage(),
                routes: [
                  GoRoute(
                    path: ':slug',
                    builder: (context, state) {
                      final slug = state.pathParameters['slug'] ?? '';
                      final essay = MindEssayRepository().bySlug(slug);
                      if (essay == null) {
                        return _MissingMindEssay(slug: slug);
                      }
                      return MindEssayPage(essay: essay);
                    },
                  ),
                ],
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
      body: Center(
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
      ),
    ),
  );
}

class _MissingLifeType extends StatelessWidget {
  const _MissingLifeType({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('‘$slug’에 해당하는 인생 유형을 찾을 수 없습니다.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.lifePaths),
              child: const Text('노후맞이 인생들 전체보기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingMindEssay extends StatelessWidget {
  const _MissingMindEssay({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('‘$slug’ 읽을거리를 찾을 수 없습니다.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.mindLounge),
              child: const Text('마음쉼터 전체보기'),
            ),
          ],
        ),
      ),
    );
  }
}
