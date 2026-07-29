import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../services/life_scenario_repository.dart';
import '../../shared/widgets/common_widgets.dart';

class FiveLivesPage extends StatelessWidget {
  const FiveLivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final types = LifeScenarioRepository().lifeTypes;
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '다섯 가지 인생',
            subtitle: '입력 없이 유형을 비교합니다. 같은 형식으로 정리되어 있어 자신의 삶과 겹쳐 볼 수 있습니다.',
          ),
          const SizedBox(height: 16),
          for (final t in types) ...[
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(t.subtitle),
                  const SizedBox(height: 8),
                  Text('가장 큰 장점: ${t.biggestStrength}'),
                  Text('놓치기 쉬운 위험: ${t.easiestMissedRisk}'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go(
                      AppRoutes.lifeDetail(LifeScenarioRepository.slugOf(t.id)),
                    ),
                    child: const Text('이 인생 자세히 읽기'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SiteFooter(),
        ],
      ),
    );
  }
}
