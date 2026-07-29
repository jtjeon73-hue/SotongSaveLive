import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/official_sources_data.dart';
import '../../data/rural_life_data.dart';
import '../../models/life_models.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/widgets/related_life_paths_panel.dart';

class RuralLifePage extends StatelessWidget {
  const RuralLifePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '농촌과 제2의 인생',
            subtitle: '낭만만 말하지 않습니다. 체력·의료·교통·소득 변동과 관계까지 함께 읽습니다.',
          ),
          const SizedBox(height: 16),
          _block('농촌으로 가기 전', RuralLifeData.beforeMove),
          _block('농촌에서 살아가기', RuralLifeData.livingThere),
          _block('고령 농촌생활', RuralLifeData.agingRural),
          const SectionHeader(title: 'AI가 분석한 농촌생활 시나리오'),
          const SizedBox(height: 8),
          for (final s in RuralLifeData.scenarios) ...[
            SoftPanel(
              accent: AppColors.forest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '장점',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  BulletList(s.pros),
                  const Text(
                    '위험',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  BulletList(s.risks),
                  const Text(
                    '필요한 준비',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  BulletList(s.neededPrep),
                  const Text(
                    '실패 가능성을 줄이는 순서',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  BulletList(s.reduceFailureOrder),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          AiAnalysisPanel(card: RuralLifeData.analysis),
          const SizedBox(height: 12),
          SoftPanel(
            accent: AppColors.gold,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '농촌에서 계속 살 수 있는 조건과 이동',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const BulletList([
                  '읍·중소도시 생활권 이동',
                  '운전 중단 후 교통·병원',
                  '지방 고령자주택·합리적인 노후주거',
                ]),
                OutlinedButton(
                  onPressed: () => context.go(AppRoutes.housingCare),
                  child: const Text('노후 주거·돌봄에서 자세히 읽기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TradeOffTable(rows: RuralLifeData.tradeOffs),
          const SizedBox(height: 12),
          BranchMap(branches: RuralLifeData.branches),
          const SizedBox(height: 12),
          const RelatedLifePathsPanel(
            title: '농촌생활과 함께 읽어볼 인생',
            links: [
              (
                id: LifeTypeId.ruralLife,
                reason: '이미 농촌에서 일하는 삶의 전체 전략을 이어서 볼 수 있습니다.',
              ),
              (
                id: LifeTypeId.childfreeCouple,
                reason: '자녀 없는 부부의 농촌 유지·생활권 이동 시나리오와 연결됩니다.',
              ),
              (
                id: LifeTypeId.freelancer,
                reason: '기술·프리랜서 일과 농촌생활을 병행하는 시나리오와 연결됩니다.',
              ),
              (
                id: LifeTypeId.craftCreative,
                reason: '전문기술·창작은 농촌에서 교육·콘텐츠 수익으로 이어질 수 있습니다.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          SourceFooter(
            sources: OfficialSourceRepository.sources
                .where(
                  (s) =>
                      s.id == 'greendaero' ||
                      s.id == 'mafra' ||
                      s.id == 'rda' ||
                      s.id == 'kostat',
                )
                .toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  Widget _block(String title, List<(String, List<String>)> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 8),
        for (final t in topics) ...[
          SoftPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                BulletList(t.$2),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
