import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/health_life_data.dart';
import '../../data/official_sources_data.dart';
import '../../models/life_models.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/widgets/related_life_paths_panel.dart';

class HealthLifePage extends StatelessWidget {
  const HealthLifePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '건강·관계·생활',
            subtitle: '질병 백과가 아닙니다. 오래 움직이고, 관계를 지키며, 하루를 풍요롭게 만드는 관점을 읽습니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(
            accent: AppColors.gold,
            child: const Text(
              '의료정보는 공식 출처와 전문가 확인이 필요합니다. '
              '본 내용은 일반적인 생활 관점이며 개인 맞춤 진단·처방이 아닙니다.',
            ),
          ),
          const SizedBox(height: 20),
          _section('건강', HealthLifeData.health),
          _section('배우자와 가족', HealthLifeData.spouseFamily),
          _section('친구·지역사회', HealthLifeData.friendsCommunity),
          _section('행복한 생활', HealthLifeData.happyLife),
          SoftPanel(
            accent: AppColors.sage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '행복한 하루 예시',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(HealthLifeData.happyDay),
                const SizedBox(height: 10),
                const Text(
                  '균형 잡힌 일주일 예시',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(HealthLifeData.balancedWeek),
                const SizedBox(height: 10),
                const Text(
                  '계절별 생활 예시',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(HealthLifeData.seasonalLiving),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AiAnalysisPanel(card: HealthLifeData.analysis),
          const SizedBox(height: 12),
          TradeOffTable(rows: HealthLifeData.tradeOffs),
          const SizedBox(height: 12),
          BranchMap(branches: HealthLifeData.branches),
          const SizedBox(height: 12),
          const RelatedLifePathsPanel(
            title: '관계·생활과 함께 읽어볼 인생',
            links: [
              (
                id: LifeTypeId.coupleRetirement,
                reason: '부부 노후는 건강·시간·돌봄 역할 대화와 직결됩니다.',
              ),
              (
                id: LifeTypeId.soloHousehold,
                reason: '1인 가구는 고립 예방과 응급·주거 설계가 특히 중요합니다.',
              ),
              (
                id: LifeTypeId.homemakerCaregiver,
                reason: '가족돌봄 중심 삶은 자기 삶과 관계의 중심 이동을 함께 봅니다.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          SourceFooter(
            sources: OfficialSourceRepository.sources
                .where(
                  (s) =>
                      s.id == 'mohw' ||
                      s.id == 'ltci' ||
                      s.id == 'nps_center' ||
                      s.id == 'kostat',
                )
                .toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  Widget _section(String title, List<(String, List<String>)> topics) {
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
