import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../models/life_models.dart';

class PageScaffoldBody extends StatelessWidget {
  const PageScaffoldBody({super.key, required this.child, this.maxWidth = 980});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar({super.key, required this.items});

  final List<({String label, String? path})> items;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '경로 탐색',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text('›', style: TextStyle(color: AppColors.muted)),
              ),
            if (items[i].path != null)
              InkWell(
                onTap: () => GoRouter.of(context).go(items[i].path!),
                child: Text(
                  items[i].label,
                  style: const TextStyle(
                    color: AppColors.forest,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            else
              Text(
                items[i].label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
          ],
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: AppColors.navy),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
          ),
        ],
      ],
    );
  }
}

class SoftPanel extends StatelessWidget {
  const SoftPanel({
    super.key,
    required this.child,
    this.accent = AppColors.sage,
  });

  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class BulletList extends StatelessWidget {
  const BulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '·  ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}

class SourceFooter extends StatelessWidget {
  const SourceFooter({super.key, required this.sources});

  final List<OfficialSource> sources;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      accent: AppColors.gold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '공식 출처 · 확인일 기준',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            '금액·세율·수급요건은 시점에 따라 달라질 수 있습니다. '
            '개인 맞춤 법률·세무·의료·투자 조언이 아닙니다.',
          ),
          const SizedBox(height: 12),
          for (final s in sources)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => openExternal(s.url),
                child: Text(
                  '${s.agency} — ${s.title} (확인일 ${s.checkedOn})',
                  style: const TextStyle(
                    color: AppColors.forest,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AiAnalysisPanel extends StatelessWidget {
  const AiAnalysisPanel({super.key, required this.card});

  final AiAnalysisCard card;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      accent: AppColors.forest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI 인생분석 카드',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.forest,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _block('현재 유형의 강점', card.strengths),
          _block('앞으로 커지는 위험', card.growingRisks),
          _block('놓치기 쉬운 변화', card.easyToMiss),
          _block('선택 가능한 경로', card.paths),
          _block('각 경로의 장점과 대가', card.pathTradeoffs),
          _block('가장 늦기 전에 준비할 일', card.prepareBeforeLate),
          _block('배우자와 함께 결정할 일', card.decideWithSpouse),
          _block('전문가 확인이 필요한 일', card.needsExpertCheck),
        ],
      ),
    );
  }

  Widget _block(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          BulletList(items),
        ],
      ),
    );
  }
}

class TradeOffTable extends StatelessWidget {
  const TradeOffTable({super.key, required this.rows});

  final List<TradeOffRow> rows;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택의 결과 비교',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final r in rows) ...[
            Text(r.choice, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text('단기: ${r.shortTerm}'),
            Text('5년 후: ${r.fiveYear}'),
            Text('10년 후: ${r.tenYear}'),
            Text('주의점: ${r.caution}'),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class BranchMap extends StatelessWidget {
  const BranchMap({super.key, required this.branches});

  final List<DecisionBranch> branches;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      accent: AppColors.terracotta,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '미래 분기 지도',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final b in branches) ...[
            Text(
              b.trigger,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Text('이유: ${b.why}'),
            BulletList(b.steps),
            Text('다음 행동: ${b.nextAction}'),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class ScenarioPanel extends StatelessWidget {
  const ScenarioPanel({super.key, required this.scenario});

  final RetirementScenario scenario;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scenario.title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text('상황: ${scenario.situation}'),
          Text('가장 먼저 달라지는 것: ${scenario.firstChanges}'),
          const SizedBox(height: 6),
          const Text(
            '놓치기 쉬운 위험',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          BulletList(scenario.easyToMissRisks),
          Text('준비 차이: ${scenario.preparedVsUnprepared}'),
          const Text('대응 순서', style: TextStyle(fontWeight: FontWeight.w700)),
          BulletList(scenario.responseOrder),
          Text('다시 안정되는 경로: ${scenario.recoveryPath}'),
        ],
      ),
    );
  }
}

Future<void> openExternal(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class OfficialLinkTile extends StatelessWidget {
  const OfficialLinkTile({
    super.key,
    required this.agency,
    required this.title,
    required this.url,
    required this.checkedOn,
    this.note,
  });

  final String agency;
  final String title;
  final String url;
  final String checkedOn;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => openExternal(url),
          child: Text(
            '$agency — $title (확인일 $checkedOn)',
            style: const TextStyle(
              color: AppColors.forest,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (note != null && note!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            note!,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ],
      ],
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'SotongSaveLive',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.forest,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '오늘을 제대로 살아가고, 남은 삶을 아름답게 설계하며, '
            '마지막까지 나다운 삶을 지켜주는 AI 인생설계 플랫폼',
          ),
          const SizedBox(height: 8),
          const Text(
            '본 사이트는 일반적인 인생·노후 준비 관점을 제공합니다. '
            '의료·연금·투자·세무·법률에 대한 확정 조언이 아니며, '
            '개인정보를 수집하거나 저장하지 않습니다.',
          ),
        ],
      ),
    );
  }
}
