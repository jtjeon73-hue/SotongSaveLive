import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../services/crisis_session_controller.dart';
import '../../shared/widgets/common_widgets.dart';

class IncidentFollowUpPage extends StatelessWidget {
  const IncidentFollowUpPage({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final crisis = controller.crisis;
        final prevention = controller.lastPrevention;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(
                    title: '사건 추적·재발방지',
                    subtitle: '시작부터 종료까지 시간순으로 남기고, 다시 발생하지 않기 위한 점검을 만듭니다.',
                  ),
                  const SizedBox(height: 16),
                  if (crisis == null)
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.assess),
                      child: const Text('새 사건 시작'),
                    )
                  else ...[
                    const Text(
                      '시간순 추적',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    for (final e in crisis.timeline)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.timeline),
                        title: Text(e.label),
                        subtitle: Text('${e.at.toLocal()}\n${e.detail ?? ''}'),
                        isThreeLine: true,
                      ),
                    const SizedBox(height: 12),
                    if (!crisis.isClosed)
                      FilledButton(
                        onPressed: () async {
                          await controller.closeIncident();
                        },
                        child: const Text('사건 종료 및 재발방지 계획 생성'),
                      ),
                    if (prevention != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        prevention.summary,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      _block('잘 대응한 부분', prevention.whatWentWell),
                      _block('확인하지 못한 부분', prevention.unknownGaps),
                      _block('다시 준비할 장비', prevention.equipmentToPrepare),
                      _block('가족과 공유할 사항', prevention.shareWithFamily),
                      _block('센서·시설 개선안', prevention.facilityImprovements),
                      _block('후속 전문기관 확인', prevention.followUpChecks),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _block(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          for (final i in items) Text('· $i'),
        ],
      ),
    );
  }
}
