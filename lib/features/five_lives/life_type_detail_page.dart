import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/official_sources_data.dart';
import '../../models/life_models.dart';
import '../../shared/widgets/common_widgets.dart';

class LifeTypeDetailPage extends StatelessWidget {
  const LifeTypeDetailPage({super.key, required this.profile});

  final LifeTypeProfile profile;

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: profile.title, subtitle: profile.subtitle),
          const SizedBox(height: 16),
          SoftPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '이 삶의 특징',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                BulletList(profile.traits),
                const SizedBox(height: 8),
                Text('가장 큰 장점: ${profile.biggestStrength}'),
                Text('가장 놓치기 쉬운 위험: ${profile.easiestMissedRisk}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftPanel(
            accent: AppColors.gold,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '연령대별 변화',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                for (final e in profile.stageChanges.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('${_stageLabel(e.key)}: ${e.value}'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _domain('돈', profile.money),
          _domain('일', profile.work),
          _domain('건강', profile.health),
          _domain('관계', profile.relationships),
          _domain('주거', profile.housing),
          _domain('배우자와 가족', profile.family),
          _domain('위기 발생 시 대안', profile.crisisAlternatives),
          _domain('AI가 제안하는 10년 전략', profile.tenYearStrategy),
          SoftPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '좋은 노후와 어려운 노후의 갈림길',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text('좋은 노후 쪽: ${profile.forkGood}'),
                const SizedBox(height: 6),
                Text('어려운 노후 쪽: ${profile.forkHard}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '지금 참고할 핵심 5가지',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                BulletList(profile.coreFive),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftPanel(
            accent: AppColors.terracotta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '주요 위험',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                BulletList(profile.risks),
                const SizedBox(height: 8),
                const Text(
                  '실행 우선순위',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                BulletList(profile.priorities),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: '대표 시나리오'),
          const SizedBox(height: 8),
          for (final s in profile.scenarios) ...[
            ScenarioPanel(scenario: s),
            const SizedBox(height: 12),
          ],
          AiAnalysisPanel(card: profile.analysis),
          const SizedBox(height: 16),
          TradeOffTable(rows: profile.tradeOffs),
          const SizedBox(height: 16),
          BranchMap(branches: profile.branches),
          const SizedBox(height: 16),
          SourceFooter(
            sources: OfficialSourceRepository.sources.take(5).toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  Widget _domain(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            BulletList(items),
          ],
        ),
      ),
    );
  }

  String _stageLabel(LifeStageId id) {
    switch (id) {
      case LifeStageId.forties:
        return '40대';
      case LifeStageId.fifties:
        return '50대';
      case LifeStageId.sixties:
        return '60대';
      case LifeStageId.seventies:
        return '70대';
      case LifeStageId.eightiesPlus:
        return '80대 이후';
    }
  }
}
