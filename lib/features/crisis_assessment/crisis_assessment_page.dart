import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../models/question_models.dart';
import '../../services/crisis_session_controller.dart';
import '../../shared/widgets/common_widgets.dart';

class CrisisAssessmentPage extends StatefulWidget {
  const CrisisAssessmentPage({
    super.key,
    required this.controller,
    this.initialText = '',
    this.witnessMode = false,
  });

  final CrisisSessionController controller;
  final String initialText;
  final bool witnessMode;

  @override
  State<CrisisAssessmentPage> createState() => _CrisisAssessmentPageState();
}

class _CrisisAssessmentPageState extends State<CrisisAssessmentPage> {
  late final TextEditingController _text;
  late final TextEditingController _location;
  QuickSituation? _situation;
  SubjectType _subject = SubjectType.self;
  AloneStatus _alone = AloneStatus.unknown;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: widget.initialText);
    _location = TextEditingController();
    if (widget.controller.crisis != null && !widget.witnessMode) {
      _started = true;
    }
    if (widget.witnessMode) {
      _subject = SubjectType.other;
    }
  }

  @override
  void dispose() {
    _text.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    await widget.controller.startAssessment(
      freeText: _text.text.trim(),
      situation: _situation,
      subjectType: _subject,
      aloneStatus: _alone,
      locationText: _location.text.trim(),
      isWitnessMode: widget.witnessMode,
    );
    setState(() => _started = true);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final crisis = c.crisis;
    final question = c.nextQuestion;

    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(
                    title: widget.witnessMode
                        ? '다른 사람을 살려주세요'
                        : 'AI가 지금 내 상황 판단',
                    subtitle: widget.witnessMode
                        ? '목격자가 대신 입력합니다. 질문을 한 단계씩 진행하며, 현장 안전을 먼저 확인합니다.'
                        : '한 번에 하나씩만 묻습니다. 답하면 위험도와 행동이 다시 계산됩니다.',
                  ),
                  const SizedBox(height: 12),
                  const SafetyDisclaimerBanner(compact: true),
                  const SizedBox(height: 16),
                  if (!_started || crisis == null) ...[
                    TextField(
                      controller: _text,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: '자유 문장 입력',
                        hintText: '아는 만큼만 편하게 적어 주세요',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '빠른 상황 선택',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final s in QuickSituation.values)
                          ChoiceChip(
                            label: Text(s.labelKo),
                            selected: _situation == s,
                            onSelected: (_) => setState(() => _situation = s),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!widget.witnessMode)
                      SegmentedButton<SubjectType>(
                        segments: const [
                          ButtonSegment(
                            value: SubjectType.self,
                            label: Text('본인'),
                          ),
                          ButtonSegment(
                            value: SubjectType.other,
                            label: Text('다른 사람'),
                          ),
                        ],
                        selected: {_subject},
                        onSelectionChanged: (v) =>
                            setState(() => _subject = v.first),
                      ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<AloneStatus>(
                      // ignore: deprecated_member_use
                      value: _alone,
                      decoration: const InputDecoration(labelText: '혼자 있음 여부'),
                      items: const [
                        DropdownMenuItem(
                          value: AloneStatus.alone,
                          child: Text('혼자 있음'),
                        ),
                        DropdownMenuItem(
                          value: AloneStatus.withOthers,
                          child: Text('다른 사람과 함께'),
                        ),
                        DropdownMenuItem(
                          value: AloneStatus.unknown,
                          child: Text('확인 불가'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _alone = v ?? AloneStatus.unknown),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _location,
                      decoration: const InputDecoration(
                        labelText: '현재 위치 (선택 입력)',
                        hintText: '예: ○○마을 밭 / ○○공장 2동',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Wrap(
                      spacing: 8,
                      children: [
                        ComingSoonChip(label: '음성 입력'),
                        ComingSoonChip(label: '사진 입력'),
                        ComingSoonChip(label: '자동 위치'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _start,
                      child: Text(
                        widget.witnessMode ? '목격자 모드 시작' : '상황 파악 시작',
                      ),
                    ),
                  ] else ...[
                    if (crisis.assessment != null) ...[
                      RiskBadge(level: crisis.assessment!.level),
                      const SizedBox(height: 8),
                      Text(
                        '우선 위험: ${crisis.assessment!.primaryRisk}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(crisis.assessment!.summary),
                      const SizedBox(height: 8),
                      ExpansionTile(
                        title: const Text('판단 근거·적용 규칙'),
                        children: [
                          for (final f in crisis.assessment!.factors)
                            ListTile(
                              dense: true,
                              title: Text(f.label),
                              subtitle: Text(f.reason),
                              trailing: Text(f.level.labelKo),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '규칙: ${crisis.assessment!.appliedRules.join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (question != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD5DEE7)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '다음 확인 (한 가지만)',
                              style: TextStyle(
                                color: AppColors.teal,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.prompt,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                            if (question.helpText != null) ...[
                              const SizedBox(height: 8),
                              Text(question.helpText!),
                            ],
                            const SizedBox(height: 16),
                            for (final opt in question.options) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  onPressed: () => c.answerCurrent(opt),
                                  child: Text(opt.label),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ] else ...[
                      const Text(
                        '핵심 확인이 끝났습니다. 지휘센터에서 지금 할 일을 진행하세요.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => context.go(AppRoutes.command),
                        icon: const Icon(Icons.emergency),
                        label: const Text('생명구조 지휘센터로 이동'),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (crisis.answers.isNotEmpty)
                      ExpansionTile(
                        title: const Text('이전 답변 수정'),
                        children: [
                          for (final entry in crisis.answers.entries)
                            ListTile(
                              title: Text(entry.key),
                              subtitle: Text(entry.value.value.name),
                              trailing: TextButton(
                                onPressed: () => _revise(entry.key),
                                child: const Text('수정'),
                              ),
                            ),
                        ],
                      ),
                    TextButton(
                      onPressed: () => setState(() => _started = false),
                      child: const Text('처음부터 다시 입력'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _revise(String questionId) async {
    final option = await showModalBottomSheet<QuestionOption>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final opt in SituationQuestionEngineOptions.standard)
              ListTile(
                title: Text(opt.label),
                onTap: () => Navigator.pop(ctx, opt),
              ),
          ],
        ),
      ),
    );
    if (option != null) {
      await widget.controller.reviseAnswer(questionId, option);
    }
  }
}

class SituationQuestionEngineOptions {
  static const standard = [
    QuestionOption(id: 'yes', label: '예', value: AnswerValue.yes),
    QuestionOption(id: 'no', label: '아니오', value: AnswerValue.no),
    QuestionOption(
      id: 'unknown',
      label: '확인할 수 없음',
      value: AnswerValue.unknown,
    ),
  ];
}
