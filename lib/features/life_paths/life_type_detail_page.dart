import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/official_sources_data.dart';
import '../../models/life_models.dart';
import '../../services/life_scenario_repository.dart';
import '../../shared/widgets/common_widgets.dart';

class LifeTypeDetailPage extends StatefulWidget {
  const LifeTypeDetailPage({super.key, required this.profile});

  final LifeTypeProfile profile;

  @override
  State<LifeTypeDetailPage> createState() => _LifeTypeDetailPageState();
}

class _LifeTypeDetailPageState extends State<LifeTypeDetailPage> {
  final _scrollKey = GlobalKey();

  @override
  void didUpdateWidget(covariant LifeTypeDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.id != widget.profile.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _scrollKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0,
            duration: const Duration(milliseconds: 200),
          );
        }
      });
    }
  }

  void _goTo(LifeTypeProfile p) {
    context.go(AppRoutes.lifeDetail(p.slug));
  }

  @override
  Widget build(BuildContext context) {
    final repo = LifeScenarioRepository();
    final profile = widget.profile;
    final all = repo.lifeTypes;
    final prev = repo.previousCyclic(profile);
    final next = repo.nextCyclic(profile);
    final related = repo.relatedFor(profile);

    return PageScaffoldBody(
      child: Column(
        key: _scrollKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BreadcrumbBar(
            items: [
              (label: '홈', path: AppRoutes.home),
              (label: '노후맞이 인생들', path: AppRoutes.lifePaths),
              (label: profile.title, path: null),
            ],
          ),
          const SizedBox(height: 16),
          SoftPanel(
            accent: AppColors.forest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '다른 노후맞이 인생 보기',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in all)
                      ChoiceChip(
                        label: Text(t.title),
                        selected: t.id == profile.id,
                        onSelected: (_) {
                          if (t.id != profile.id) _goTo(t);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 20),
          if (related.isNotEmpty) ...[
            const SectionHeader(title: '관련 인생 추천'),
            const SizedBox(height: 8),
            for (final r in related) ...[
              SoftPanel(
                child: InkWell(
                  onTap: () => _goTo(r.profile),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.profile.title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(r.reason),
                      const SizedBox(height: 6),
                      const Text(
                        '살펴보기 →',
                        style: TextStyle(
                          color: AppColors.forest,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
          SoftPanel(
            accent: AppColors.navy,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => _goTo(prev),
                  child: Text(
                    '이전 · ${prev.title}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.lifePaths),
                  child: const Text('노후맞이 인생들 전체보기'),
                ),
                OutlinedButton(
                  onPressed: () => _goTo(next),
                  child: Text(
                    '다음 · ${next.title}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
