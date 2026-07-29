import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/official_sources_data.dart';
import '../../models/life_models.dart';
import '../../services/life_roadmap_service.dart';
import '../../shared/widgets/common_widgets.dart';

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  late LifeStageId _selected;

  @override
  void initState() {
    super.initState();
    _selected = LifeRoadmapService().stages.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final stages = LifeRoadmapService().stages;
    final current = stages.firstWhere((s) => s.id == _selected);

    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: 'AI 인생로드맵',
            subtitle: '사용자 입력 없이 연령대별 인생지도와 미래 시나리오를 보여줍니다.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in stages)
                ChoiceChip(
                  label: Text(s.title),
                  selected: _selected == s.id,
                  onSelected: (_) => setState(() => _selected = s.id),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SoftPanel(
            accent: AppColors.forest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  current.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(current.focus),
                const SizedBox(height: 12),
                const Text(
                  '이 시기의 준비',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                BulletList(current.items),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(
            title: 'AI 미래 시나리오',
            subtitle: '안정 · 변화 대응 · 위기 시나리오를 같은 형식으로 비교합니다.',
          ),
          const SizedBox(height: 12),
          for (final sc in current.scenarios) ...[
            ScenarioPanel(scenario: sc),
            const SizedBox(height: 12),
          ],
          SourceFooter(
            sources: OfficialSourceRepository.sources.take(5).toList(),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
