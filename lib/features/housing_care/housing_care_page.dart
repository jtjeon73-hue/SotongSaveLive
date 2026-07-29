import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/housing_care_data.dart';
import '../../models/housing_models.dart';
import '../../models/life_models.dart';
import '../../shared/widgets/common_widgets.dart';
import '../../shared/widgets/related_life_paths_panel.dart';

class HousingCarePage extends StatefulWidget {
  const HousingCarePage({super.key});

  @override
  State<HousingCarePage> createState() => _HousingCarePageState();
}

class _HousingCarePageState extends State<HousingCarePage> {
  final _housingTypesKey = GlobalKey();
  final _carePathKey = GlobalKey();
  final _childfreeKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      alignment: 0.05,
    );
  }

  GlobalKey _keyFor(String sectionId) {
    return switch (sectionId) {
      'care-path' => _carePathKey,
      'childfree-scenarios' => _childfreeKey,
      _ => _housingTypesKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SoftPanel(
            accent: AppColors.forest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HousingCareData.heroTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(HousingCareData.heroBody),
                const SizedBox(height: 12),
                Text(
                  HousingCareData.disclaimer,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 8),
                Text(
                  '기준일(확인일): ${HousingCareData.checkedAt}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.forest,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: '지금 가까운 상황을 골라 읽어보세요',
            subtitle: '선택해도 저장·진단하지 않습니다. 관련 설명 위치로 이동합니다.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in HousingCareData.situations)
                ActionChip(
                  label: Text(s.title),
                  onPressed: () => _scrollTo(_keyFor(s.targetSectionId)),
                ),
            ],
          ),
          const SizedBox(height: 28),
          KeyedSubtree(
            key: _housingTypesKey,
            child: const SectionHeader(
              title: '노후주거·돌봄 유형을 정확히 구분하기',
              subtitle: '비슷한 이름이라도 목적·돌봄·의료·자격이 다릅니다.',
            ),
          ),
          const SizedBox(height: 12),
          SoftPanel(
            accent: AppColors.gold,
            child: BulletList(HousingCareData.distinctionNotes),
          ),
          const SizedBox(height: 16),
          for (final t in HousingCareData.housingTypes) ...[
            _HousingTypeCard(type: t),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
          const SectionHeader(
            title: '한눈에 보는 비교',
            subtitle: '모바일에서는 카드로, 넓은 화면에서는 표로 보여 줍니다.',
          ),
          const SizedBox(height: 12),
          const _ComparisonBlock(),
          const SizedBox(height: 28),
          KeyedSubtree(
            key: _carePathKey,
            child: const SectionHeader(
              title: '건강상태별 주거·돌봄 전환지도',
              subtitle: '개인 진단이 아닙니다. 대표 경로를 읽고 공식 경로로 확인하세요.',
            ),
          ),
          const SizedBox(height: 12),
          for (final stage in HousingCareData.carePath.stages) ...[
            _CareStageCard(stage: stage),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
          KeyedSubtree(
            key: _childfreeKey,
            child: const SectionHeader(
              title: '자녀 없는 부부의 주거 시나리오',
              subtitle: '장점·위험·준비·계획 변경 신호를 함께 봅니다.',
            ),
          ),
          const SizedBox(height: 12),
          for (final s in HousingCareData.childfreeScenarios) ...[
            _ChildfreeScenarioCard(scenario: s),
            const SizedBox(height: 12),
          ],
          OutlinedButton(
            onPressed: () =>
                context.go(AppRoutes.lifeDetail('childfree-couple-retirement')),
            child: const Text('자녀 없이 부부가 함께 살아가는 노후 인생 유형 읽기'),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: '시설을 고르는 실제 점검표',
            subtitle: '입력·저장 체크리스트가 아니라, 방문·계약 전 참고 목록입니다.',
          ),
          const SizedBox(height: 12),
          for (final c in HousingCareData.checklists) ...[
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  BulletList(c.items),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 16),
          const SectionHeader(
            title: '정부 정책·공식 연결센터',
            subtitle: '전화번호는 임의로 만들지 않습니다. 자격·금액은 공고마다 달라질 수 있습니다.',
          ),
          const SizedBox(height: 12),
          SoftPanel(
            child: Column(
              children: [
                for (final s in HousingCareData.officialSources)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OfficialLinkTile(
                      agency: s.agency,
                      title: s.title,
                      url: s.url,
                      checkedOn: s.checkedAt,
                      note: s.note,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const RelatedLifePathsPanel(
            title: '함께 읽어볼 인생',
            links: [
              (
                id: LifeTypeId.childfreeCouple,
                reason: '자녀 없는 부부의 주거·돌봄·사별 준비를 깊게 다룹니다.',
              ),
              (
                id: LifeTypeId.coupleRetirement,
                reason: '일반적인 부부 노후 설계와 함께 읽습니다.',
              ),
              (
                id: LifeTypeId.soloHousehold,
                reason: '한 사람이 남았을 때의 1인 전환과 연결됩니다.',
              ),
              (id: LifeTypeId.ruralLife, reason: '농촌 유지와 생활권 이동을 함께 봅니다.'),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.healthLife),
                child: const Text('건강·관계·생활'),
              ),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.rural),
                child: const Text('농촌과 제2의 인생'),
              ),
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.legacy),
                child: const Text('아름다운 마무리'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SiteFooter(),
        ],
      ),
    );
  }
}

class _HousingTypeCard extends StatelessWidget {
  const _HousingTypeCard({required this.type});

  final SeniorHousingType type;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(
            '${type.category} · 확인일 ${type.checkedAt}',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          Text(type.summary),
          const SizedBox(height: 10),
          Text('자격·대상 개요: ${type.eligibilityOverview}'),
          Text('비용 성격: ${type.costNature}'),
          Text('돌봄: ${type.careLevel}'),
          Text('의료: ${type.medicalLevel}'),
          if (type.fitSituations.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              '적합 가능성이 높은 상황',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            BulletList(type.fitSituations),
          ],
          if (type.checkItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('확인할 점', style: TextStyle(fontWeight: FontWeight.w700)),
            BulletList(type.checkItems),
          ],
          const SizedBox(height: 8),
          const Text('장점', style: TextStyle(fontWeight: FontWeight.w700)),
          BulletList(type.advantages),
          const SizedBox(height: 8),
          const Text('주의', style: TextStyle(fontWeight: FontWeight.w700)),
          BulletList(type.cautions),
          const SizedBox(height: 8),
          OfficialLinkTile(
            agency: type.officialSource.agency,
            title: type.officialSource.title,
            url: type.officialSource.url,
            checkedOn: type.officialSource.checkedAt,
            note: type.officialSource.note,
          ),
          if (type.variesByNotice || type.expertReviewRequired)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                [
                  if (type.variesByNotice) '공고·연도마다 조건이 달라질 수 있습니다.',
                  if (type.expertReviewRequired) '전문가·공식 안내 확인이 필요합니다.',
                ].join(' '),
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComparisonBlock extends StatelessWidget {
  const _ComparisonBlock();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 900) {
      return Column(
        children: [
          for (final row in HousingCareData.comparisons) ...[
            SoftPanel(
              accent: AppColors.sage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.typeTitle,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text('독립생활: ${row.independence}'),
                  Text('주요 목적: ${row.mainPurpose}'),
                  Text('돌봄 포함: ${row.careIncluded}'),
                  Text('의료기능: ${row.medicalFunction}'),
                  Text('비용 성격: ${row.costNature}'),
                  Text('자격·등급: ${row.eligibility}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      );
    }

    return SoftPanel(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('유형')),
            DataColumn(label: Text('독립생활')),
            DataColumn(label: Text('주요 목적')),
            DataColumn(label: Text('돌봄')),
            DataColumn(label: Text('의료')),
            DataColumn(label: Text('비용')),
            DataColumn(label: Text('자격·등급')),
          ],
          rows: [
            for (final row in HousingCareData.comparisons)
              DataRow(
                cells: [
                  DataCell(Text(row.typeTitle)),
                  DataCell(Text(row.independence)),
                  DataCell(Text(row.mainPurpose)),
                  DataCell(Text(row.careIncluded)),
                  DataCell(Text(row.medicalFunction)),
                  DataCell(Text(row.costNature)),
                  DataCell(Text(row.eligibility)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CareStageCard extends StatelessWidget {
  const _CareStageCard({required this.stage});

  final CareStage stage;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      accent: AppColors.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stage.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text('선택지: ${stage.options.join(' / ')}'),
          const SizedBox(height: 8),
          const Text(
            '현재 살던 곳을 유지할 수 있는 조건',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          BulletList(stage.keepHomeConditions),
          const Text(
            '다음 단계로 전환해야 할 신호',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          BulletList(stage.transitionSignals),
          const SizedBox(height: 6),
          Text('배우자 부담: ${stage.spouseBurden}'),
          Text('경제적 고려: ${stage.moneyNotes}'),
          const SizedBox(height: 6),
          const Text(
            '공식 신청·검색 경로',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          BulletList(stage.officialPaths),
          const Text(
            '전문가와 확인할 사항',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          BulletList(stage.expertChecks),
        ],
      ),
    );
  }
}

class _ChildfreeScenarioCard extends StatelessWidget {
  const _ChildfreeScenarioCard({required this.scenario});

  final ChildfreeCoupleScenario scenario;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scenario.title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(scenario.summary),
          const SizedBox(height: 8),
          const Text('장점', style: TextStyle(fontWeight: FontWeight.w700)),
          BulletList(scenario.advantages),
          const Text('위험', style: TextStyle(fontWeight: FontWeight.w700)),
          BulletList(scenario.risks),
          const Text('필요한 준비', style: TextStyle(fontWeight: FontWeight.w700)),
          BulletList(scenario.preparations),
          const Text(
            '계획을 바꿔야 하는 신호',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          BulletList(scenario.changeSignals),
        ],
      ),
    );
  }
}
