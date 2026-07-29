import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/official_sources_data.dart';
import '../../services/life_scenario_repository.dart';
import '../../services/mind_essay_repository.dart';
import '../../shared/widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _axes = [
    '안정적인 현금흐름',
    '부담 없이 계속할 수 있는 일',
    '움직일 수 있는 건강',
    '배우자·가족·친구와의 관계',
    '편안하고 안전한 주거',
    '배우고 즐기고 기여하는 시간',
    '자신의 뜻을 존중받는 삶의 마무리',
  ];

  static const _timeline = [
    ('40대', '기반을 만드는 시기'),
    ('50대', '전환을 준비하는 시기'),
    ('60대', '일과 삶을 다시 배치하는 시기'),
    ('70대', '건강과 관계를 중심에 두는 시기'),
    ('80대 이후', '돌봄과 존엄을 준비하는 시기'),
  ];

  static const _checks = [
    '연금과 고정수입 확인',
    '불필요한 고정지출 확인',
    '앞으로 계속할 일 한 가지',
    '배우자와 함께할 시간',
    '근력과 보행능력 관리',
    '집의 안전성과 이동 편의',
    '마지막 삶에 대한 가족대화',
  ];

  @override
  Widget build(BuildContext context) {
    final types = LifeScenarioRepository().lifeTypes.take(6).toList();
    final essays = MindEssayRepository().all.take(3).toList();

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.forest, Color(0xFF2F6B52)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SotongSaveLive',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '오래 사는 것보다 중요한 것은\n남은 시간을 나답게 살아가는 것입니다.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'SotongSaveLive는 2026년 이후의 변화된 일자리, 연금, 건강, 가족, '
                  '농촌생활과 존엄한 삶의 마무리까지 AI 관점으로 연결해 보여주는 '
                  '인생·노후설계 플랫폼입니다.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: '나는 어떤 삶에 가까운가요?',
            subtitle:
                '사람의 삶은 한 가지 기준으로 나눌 수 없습니다. '
                '여러 노후맞이 인생을 읽어보고 자신과 가까운 삶을 참고해 보세요.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final t in types)
                SizedBox(
                  width: 280,
                  child: SoftPanel(
                    child: InkWell(
                      onTap: () => context.go(AppRoutes.lifeDetail(t.slug)),
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
                          const Text(
                            '자세히 읽기 →',
                            style: TextStyle(
                              color: AppColors.forest,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go(AppRoutes.lifePaths),
            child: const Text('더 많은 노후맞이 인생 보기'),
          ),
          const SizedBox(height: 8),
          Text(
            '다양한 삶이 계속 추가될 수 있습니다. 고정된 분류가 아닙니다.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: '마음쉼터',
            subtitle: '계획도 중요하지만 마음의 평안도 필요합니다.',
          ),
          const SizedBox(height: 12),
          for (final e in essays) ...[
            SoftPanel(
              accent: AppColors.sage,
              child: InkWell(
                onTap: () => context.go(AppRoutes.mindEssay(e.slug)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(e.subtitle),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.mindLounge),
            child: const Text('마음쉼터에서 조용히 읽기'),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: '노후 주거·돌봄',
            subtitle:
                '나이가 들수록 좋은 집은 크고 비싼 집보다, 안전하고 관리하기 쉬우며 필요한 도움과 가까운 집입니다.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final item in [
                ('현재 집에서 오래 살기', Icons.home_outlined),
                ('지방의 합리적인 노후주거', Icons.apartment_outlined),
                ('공공 고령자주택', Icons.account_balance_outlined),
                ('돌봄이 필요해질 때', Icons.volunteer_activism_outlined),
              ])
                SizedBox(
                  width: 220,
                  child: SoftPanel(
                    accent: AppColors.forest,
                    child: Row(
                      children: [
                        Icon(item.$2, color: AppColors.forest),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.$1,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go(AppRoutes.housingCare),
            child: const Text('노후 주거·돌봄 살펴보기'),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'AI가 바라본 행복한 노후의 7가지 축',
            subtitle: '국민연금공단 노후준비 4대 영역을 기본으로, 평생일·주거·돌봄·존엄한 마무리를 더해 구성했습니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(
            child: Column(
              children: [
                for (var i = 0; i < _axes.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.sand,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: AppColors.forest,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    title: Text(_axes[i]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: '인생은 한 번에 바뀌지 않습니다',
            subtitle: '연령 흐름을 따라 준비의 중심이 어떻게 옮겨가는지 봅니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(
            accent: AppColors.gold,
            child: Column(
              children: [
                for (final item in _timeline)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 88,
                          child: Text(
                            item.$1,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        Expanded(child: Text(item.$2)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.roadmap),
            child: const Text('AI 인생로드맵 보기'),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: '이번 달의 인생점검',
            subtitle: '저장하거나 개인정보를 받지 않습니다. 읽고 참고하는 공통 점검입니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(child: BulletList(_checks)),
          const SizedBox(height: 24),
          SourceFooter(
            sources: OfficialSourceRepository.sources.take(4).toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
