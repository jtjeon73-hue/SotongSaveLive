import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../services/crisis_session_controller.dart';
import '../../services/speech/speech_service.dart';
import '../../shared/widgets/common_widgets.dart';

class SituationReportPage extends StatefulWidget {
  const SituationReportPage({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  State<SituationReportPage> createState() => _SituationReportPageState();
}

class _SituationReportPageState extends State<SituationReportPage> {
  bool _large = false;
  bool _includePersonal = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final report = widget.controller.crisis?.report;
        if (report == null) {
          return Center(
            child: FilledButton(
              onPressed: () => context.go(AppRoutes.assess),
              child: const Text('먼저 상황판단을 진행하세요'),
            ),
          );
        }

        final text = _includePersonal
            ? report.rescueSummary
            : report.rescueSummary.replaceAll(
                RegExp(r'위치:.*'),
                '위치: (개인정보 제외)',
              );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(
                    title: '구조 연결·상황보고서',
                    subtitle:
                        '자동 신고·문자·전화 전송은 구현하지 않습니다. 향후 공식 연동이 필요합니다. 지금은 복사·큰글씨·읽기만 지원합니다.',
                  ),
                  const SizedBox(height: 12),
                  const ComingSoonChip(label: '자동 신고·문자·전화'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('큰 글씨 표시'),
                    value: _large,
                    onChanged: (v) => setState(() => _large = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('개인정보(위치 등) 포함'),
                    value: _includePersonal,
                    onChanged: (v) => setState(() => _includePersonal = v),
                  ),
                  SelectableText(
                    text,
                    style: TextStyle(
                      fontSize: _large ? 26 : 16,
                      height: 1.5,
                      fontWeight: _large ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: text));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('복사되었습니다.')),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('복사'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _speak(text),
                        icon: const Icon(Icons.volume_up),
                        label: const Text('음성으로 읽기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '보호자용 요약',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SelectableText(report.guardianSummary),
                  const SizedBox(height: 12),
                  const Text(
                    '구조기관 전달용 요약',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SelectableText(report.rescueSummary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _speak(String text) {
    try {
      SpeechService.speak(text);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이 환경에서는 음성 읽기를 사용할 수 없습니다.')),
        );
      }
    }
  }
}
