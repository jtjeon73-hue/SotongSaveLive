import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/money_work_data.dart';
import '../../data/official_sources_data.dart';
import '../../models/life_models.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/widgets/related_life_paths_panel.dart';

class MoneyWorkPage extends StatelessWidget {
  const MoneyWorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '돈과 평생일',
            subtitle: '자산 금액을 입력하지 않습니다. 대표 사례와 설명형 시나리오로 읽습니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(
            accent: AppColors.gold,
            child: Text(MoneyWorkData.disclaimer),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: '돈 영역'),
          const SizedBox(height: 8),
          for (final topic in MoneyWorkData.moneyTopics) ...[
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.$1,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  BulletList(topic.$2),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          const SectionHeader(title: '평생일 영역'),
          const SizedBox(height: 8),
          for (final topic in MoneyWorkData.workTopics) ...[
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.$1,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  BulletList(topic.$2),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          const SectionHeader(title: 'AI 분석: 세 가지 노후 비교'),
          const SizedBox(height: 8),
          for (final c in MoneyWorkData.comparisonCards) ...[
            SoftPanel(
              accent: AppColors.terracotta,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.$1,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text('장점: ${c.$2}'),
                  Text('단점: ${c.$3}'),
                  Text('장기 결과: ${c.$4}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          AiAnalysisPanel(card: MoneyWorkData.analysis),
          const SizedBox(height: 12),
          TradeOffTable(rows: MoneyWorkData.tradeOffs),
          const SizedBox(height: 12),
          BranchMap(branches: MoneyWorkData.branches),
          const SizedBox(height: 12),
          const RelatedLifePathsPanel(
            title: '돈·일과 함께 읽어볼 인생',
            links: [
              (
                id: LifeTypeId.secondCareer,
                reason: '재취업·제2직업은 평생일과 소득 구조를 다시 설계할 때 참고합니다.',
              ),
              (
                id: LifeTypeId.craftCreative,
                reason: '전문기술·창작은 경험을 수익으로 바꾸는 경로와 맞닿아 있습니다.',
              ),
              (
                id: LifeTypeId.financiallyTight,
                reason: '경제적 재설계가 필요할 때 현금흐름·고정비부터 보는 관점을 제공합니다.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          SourceFooter(
            sources: OfficialSourceRepository.sources
                .where(
                  (s) =>
                      s.id == 'nps' ||
                      s.id == 'fss_pension' ||
                      s.id == 'nts' ||
                      s.id == 'moel' ||
                      s.id == 'nps_center',
                )
                .toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
