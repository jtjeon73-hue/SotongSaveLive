import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../services/crisis_session_controller.dart';
import '../../shared/widgets/common_widgets.dart';

class RescueCommandPage extends StatelessWidget {
  const RescueCommandPage({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final crisis = controller.crisis;
        if (crisis == null || crisis.assessment == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('아직 진행 중인 상황이 없습니다.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go(AppRoutes.assess),
                    child: const Text('상황판단 시작'),
                  ),
                ],
              ),
            ),
          );
        }

        final assessment = crisis.assessment!;
        final urgent = assessment.level.rank >= 4;
        final pending = crisis.actionSteps
            .where((s) => s.status == ActionStatus.pending)
            .toList();
        final current = pending.isNotEmpty ? pending.first : null;
        final next = pending.length > 1 ? pending[1] : null;
        final elapsed = DateTime.now().difference(
          crisis.startedAt ?? crisis.createdAt,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(
                    title: urgent ? '긴급 지휘' : 'AI 생명구조 지휘센터',
                    subtitle: '지금 해야 할 한 가지에 집중하세요.',
                  ),
                  const SizedBox(height: 12),
                  RiskBadge(level: assessment.level),
                  const SizedBox(height: 8),
                  Text(
                    '가장 우선적인 위험: ${assessment.primaryRisk}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '경과시간: ${elapsed.inMinutes}분 ${elapsed.inSeconds % 60}초',
                  ),
                  const SizedBox(height: 16),
                  if (current != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: urgent
                            ? AppColors.danger.withValues(alpha: 0.08)
                            : AppColors.teal.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: urgent ? AppColors.danger : AppColors.teal,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '지금 해야 할 한 가지',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            current.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            current.instruction,
                            style: const TextStyle(fontSize: 17, height: 1.45),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(140, 52),
                                ),
                                onPressed: () => controller.markAction(
                                  current.id,
                                  ActionStatus.completed,
                                ),
                                child: const Text('완료'),
                              ),
                              OutlinedButton(
                                onPressed: () => controller.markAction(
                                  current.id,
                                  ActionStatus.unable,
                                ),
                                child: const Text('할 수 없음'),
                              ),
                              OutlinedButton(
                                onPressed: () => controller.markAction(
                                  current.id,
                                  ActionStatus.changed,
                                ),
                                child: const Text('상태가 달라짐'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    const Text(
                      '대기 중인 즉시 행동이 없습니다. 후속 확인과 보고서을 검토하세요.',
                      style: TextStyle(fontSize: 16),
                    ),
                  if (next != null) ...[
                    const SizedBox(height: 16),
                    Text('다음 행동: ${next.title}'),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    '하면 안 되는 행동',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  for (final p in crisis.prohibitedActions)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.block, color: AppColors.danger),
                      title: Text(p.label),
                      subtitle: Text(p.reason),
                    ),
                  const Divider(height: 32),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('구조 요청 여부'),
                    value: crisis.rescueRequested,
                    onChanged: (v) => controller.setFlags(rescue: v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('보호자 연락 여부'),
                    value: crisis.guardianContacted,
                    onChanged: (v) => controller.setFlags(guardian: v),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '현재까지 입력된 상태',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  for (final a in crisis.answers.entries)
                    Text('· ${a.key}: ${a.value.value.name}'),
                  const SizedBox(height: 16),
                  if (crisis.report != null) ...[
                    Text(
                      '전달용 상황보고서',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(crisis.report!.rescueSummary),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: crisis.report!.rescueSummary),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('보고서가 복사되었습니다.')),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('보고서 복사'),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.report),
                      child: const Text('보고서 화면에서 크게 보기'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: () async {
                      await controller.closeIncident();
                      if (context.mounted) {
                        context.go(AppRoutes.followUp);
                      }
                    },
                    child: const Text('전체 과정 종료 및 안전 확보 확인'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
