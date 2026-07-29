import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/legacy_data.dart';
import '../../data/official_sources_data.dart';
import '../../models/life_models.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/widgets/related_life_paths_panel.dart';

class LegacyPage extends StatelessWidget {
  const LegacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '아름다운 마무리',
            subtitle:
                '마지막 순간까지 자신의 뜻과 존엄을 지키고, '
                '가족에게 사랑과 정리는 남기되 혼란과 부담은 줄이는 준비입니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(
            accent: AppColors.gold,
            child: const Text(
              '이 메뉴는 죽음을 앞당기거나 죽는 방법을 안내하지 않습니다. '
              '자살·안락사 실행 정보는 포함하지 않습니다. '
              '법률·세무·의료 확정 조언이 아니며, 입력·편지 작성 기능도 없습니다.',
            ),
          ),
          const SizedBox(height: 16),
          for (final section in LegacyData.sections) ...[
            SoftPanel(
              accent: section.id == 'advance_directive'
                  ? AppColors.forest
                  : AppColors.sage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(section.summary),
                  const SizedBox(height: 8),
                  BulletList(section.points),
                  if (section.legalNote != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      section.legalNote!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                  if (section.sourceIds.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    for (final id in section.sourceIds)
                      if (OfficialSourceRepository.byId(id) != null)
                        InkWell(
                          onTap: () => openExternal(
                            OfficialSourceRepository.byId(id)!.url,
                          ),
                          child: Text(
                            '공식 안내: ${OfficialSourceRepository.byId(id)!.agency}',
                            style: const TextStyle(
                              color: AppColors.forest,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          SoftPanel(
            accent: AppColors.forest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '장기요양·호스피스와 주거 전환',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  '자녀 없는 부부의 의사결정, 한 사람이 남았을 때의 준비, '
                  '호스피스·완화의료는 노후 주거·돌봄 메뉴와 함께 읽습니다.',
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => context.go(AppRoutes.housingCare),
                  child: const Text('노후 주거·돌봄 살펴보기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const RelatedLifePathsPanel(
            title: '마무리 준비와 함께 읽어볼 인생',
            links: [
              (
                id: LifeTypeId.soloHousehold,
                reason: '혼자 사는 삶은 의사결정 전달자와 서류·계정 정리가 더 중요합니다.',
              ),
              (
                id: LifeTypeId.childfreeCouple,
                reason: '자녀 없는 부부는 사별·의사결정·돌봄 공백을 더 구체적으로 준비합니다.',
              ),
              (
                id: LifeTypeId.coupleRetirement,
                reason: '부부 노후는 한 사람이 먼저 아프거나 사별했을 때의 준비를 함께 봅니다.',
              ),
              (
                id: LifeTypeId.alreadyRetired,
                reason: '이미 은퇴한 뒤에는 정리·돌봄·존엄한 마무리를 더 구체적으로 준비합니다.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          SourceFooter(
            sources: OfficialSourceRepository.sources
                .where(
                  (s) =>
                      s.id == 'lst' ||
                      s.id == 'ltci' ||
                      s.id == 'mohw' ||
                      s.id == 'nts' ||
                      s.id == 'gov24',
                )
                .toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
