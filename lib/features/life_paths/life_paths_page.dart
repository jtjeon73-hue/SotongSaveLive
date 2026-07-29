import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../models/life_models.dart';
import '../../services/life_scenario_repository.dart';
import '../../shared/widgets/common_widgets.dart';

class LifePathsPage extends StatefulWidget {
  const LifePathsPage({super.key});

  @override
  State<LifePathsPage> createState() => _LifePathsPageState();
}

class _LifePathsPageState extends State<LifePathsPage> {
  LifeTypeCategory? _filter;

  static const _filters = <(String, LifeTypeCategory?)>[
    ('전체', null),
    ('직장·은퇴', LifeTypeCategory.careerRetirement),
    ('계속 일하기', LifeTypeCategory.keepWorking),
    ('사업·전문기술', LifeTypeCategory.businessSkill),
    ('가족·부부', LifeTypeCategory.familyCouple),
    ('혼자 사는 삶', LifeTypeCategory.livingAlone),
    ('농촌생활', LifeTypeCategory.rural),
    ('경제적 재설계', LifeTypeCategory.moneyRebuild),
  ];

  @override
  Widget build(BuildContext context) {
    final repo = LifeScenarioRepository();
    final items = repo.filterByCategory(_filter);
    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width >= 900
        ? 300.0
        : (width >= 600 ? 280.0 : double.infinity);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '노후맞이 인생들',
            subtitle:
                '사람의 삶은 한 가지 기준으로 나눌 수 없습니다. '
                '지금까지 살아온 방식, 일, 가족, 건강, 경제상황과 앞으로 원하는 삶에 따라 '
                '노후의 모습도 달라집니다. 여러 노후맞이 인생을 읽어보고 '
                '자신과 가까운 삶에서 필요한 방향을 참고해 보세요.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in _filters)
                ChoiceChip(
                  label: Text(f.$1),
                  selected: _filter == f.$2,
                  onSelected: (_) => setState(() => _filter = f.$2),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final t in items)
                SizedBox(
                  width: cardWidth == double.infinity ? null : cardWidth,
                  child: SoftPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(t.subtitle),
                        const SizedBox(height: 8),
                        Text(
                          '장점: ${t.biggestStrength}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '주의할 변화: ${t.easiestMissedRisk}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            for (final tag in t.tags.take(4))
                              Chip(
                                label: Text(tag),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: () =>
                              context.go(AppRoutes.lifeDetail(t.slug)),
                          child: const Text('이 인생 살펴보기'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '유형은 고정된 최종 분류가 아닙니다. 앞으로 더 다양한 노후맞이 인생이 추가될 수 있습니다.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
