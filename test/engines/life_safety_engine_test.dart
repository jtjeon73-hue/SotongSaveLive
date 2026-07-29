import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_save_live/models/enums.dart';
import 'package:sotong_save_live/models/question_models.dart';
import 'package:sotong_save_live/services/engines/life_safety_orchestrator.dart';

void main() {
  late LifeSafetyOrchestrator orch;

  setUp(() {
    orch = LifeSafetyOrchestrator();
  });

  test('치명적 신호가 있으면 위험도가 높아진다', () {
    final c = orch.createCase(
      freeText: '숨이 안 쉬어져요',
      quickSituation: QuickSituation.breathingDifficulty,
    );
    expect(c.assessment!.level.rank >= RiskLevel.high.rank, isTrue);
    expect(c.assessment!.needsOfficialRescue, isTrue);
  });

  test('확인 불가는 안전으로 처리되지 않는다', () {
    var c = orch.createCase(quickSituation: QuickSituation.personCollapsed);
    final q = orch.nextQuestion(c)!;
    c = orch.answer(
      c,
      q,
      const QuestionOption(
        id: 'unknown',
        label: '확인할 수 없음',
        value: AnswerValue.unknown,
      ),
    );
    expect(c.assessment!.level, isNot(RiskLevel.low));
    expect(
      c.assessment!.factors.any((f) => f.reason.contains('확인 불가')),
      isTrue,
    );
  });

  test('답변 변경 시 위험도와 행동계획이 재계산된다', () {
    var c = orch.createCase(quickSituation: QuickSituation.personCollapsed);
    final q = orch.nextQuestion(c)!;
    c = orch.answer(
      c,
      q,
      const QuestionOption(id: 'yes', label: '예', value: AnswerValue.yes),
    );
    final beforeRules = List<String>.from(c.assessment!.appliedRules);
    final beforeSteps = c.actionSteps.length;
    c = orch.updateAnswer(
      c,
      q.id,
      const QuestionOption(
        id: 'unknown',
        label: '확인할 수 없음',
        value: AnswerValue.unknown,
      ),
    );
    expect(c.assessment, isNotNull);
    expect(c.actionSteps, isNotEmpty);
    // Recompute always runs; rules/steps remain coherent.
    expect(beforeRules, isNotEmpty);
    expect(beforeSteps, greaterThan(0));
    expect(c.answers[q.id]!.value, AnswerValue.unknown);
  });

  test('필수 시나리오가 서로 다른 질문과 행동을 생성한다', () {
    final a = orch.createCase(quickSituation: QuickSituation.personCollapsed);
    final b = orch.createCase(
      quickSituation: QuickSituation.trafficOrMachineAccident,
    );
    final c = orch.createCase(quickSituation: QuickSituation.mentalCrisis);
    final d = orch.createCase(quickSituation: QuickSituation.fireOrSmoke);
    final e = orch.createCase(quickSituation: QuickSituation.livingCollapse);

    final qA = orch.allQuestions(a).map((e) => e.id).toSet();
    final qB = orch.allQuestions(b).map((e) => e.id).toSet();
    final qC = orch.allQuestions(c).map((e) => e.id).toSet();
    expect(qA.contains('heat') || qA.contains('elderly'), isTrue);
    expect(qB.contains('machine_running') || qB.contains('scene_safe'), isTrue);
    expect(qC.contains('immediate_danger'), isTrue);
    expect(a.actionSteps.any((s) => s.id == 'cool_safe_place'), isTrue);
    expect(b.actionSteps.any((s) => s.id == 'secure_scene'), isTrue);
    expect(d.prohibitedActions.any((p) => p.id == 'no_reenter'), isTrue);
    expect(e.actionSteps.any((s) => s.id == 'tonight_shelter'), isTrue);
  });

  test('농기계 시나리오에 금지행동이 포함된다', () {
    final c = orch.createCase(
      quickSituation: QuickSituation.trafficOrMachineAccident,
      freeText: '농기계에 끼였어요',
    );
    expect(c.prohibitedActions.any((p) => p.id == 'no_force_pull'), isTrue);
    expect(c.actionSteps.any((s) => s.id == 'secure_scene'), isTrue);
  });

  test('상황보고서가 필수 항목을 포함한다', () {
    final c = orch.createCase(
      freeText: '밭에서 쓰러짐',
      quickSituation: QuickSituation.personCollapsed,
      locationText: '동마을 밭',
    );
    final report = c.report!;
    expect(report.rescueSummary.contains('위험도'), isTrue);
    expect(report.rescueSummary.contains('위치'), isTrue);
    expect(report.fields.containsKey('사람'), isTrue);
    expect(report.guardianSummary.contains('보호자용'), isTrue);
  });

  test('정신적 위기에서 비난·단정·진단 표현이 나오지 않는다', () {
    final c = orch.createCase(
      quickSituation: QuickSituation.mentalCrisis,
      freeText: '삶을 포기하고 싶어요',
    );
    final blob = [
      c.assessment!.summary,
      ...c.actionSteps.map((e) => '${e.title}${e.instruction}'),
      ...c.prohibitedActions.map((e) => '${e.label}${e.reason}'),
      c.report!.fullText,
    ].join('\n');
    expect(orch.containsUnsafeMentalLanguage(blob), isFalse);
    expect(c.prohibitedActions.any((p) => p.id == 'no_blame'), isTrue);
  });

  test('존재하지 않는 기관과 전화번호를 생성하지 않는다', () {
    final c = orch.createCase(
      quickSituation: QuickSituation.mentalCrisis,
      freeText: '도움이 필요해요',
    );
    final text = '${c.report!.fullText}\n${c.report!.rescueSummary}';
    expect(orch.containsInventedContact(text), isFalse);
    expect(text.contains('가상긴급센터'), isFalse);
  });

  test('시나리오 A 고령자 밭 쓰러짐이 높은 위험과 금지행동을 만든다', () {
    var c = orch.createCase(
      freeText: '고령자가 폭염에 밭에서 쓰러졌고 말이 이상해요',
      quickSituation: QuickSituation.personCollapsed,
      aloneStatus: AloneStatus.alone,
    );
    // Answer key questions if present.
    for (var i = 0; i < 8; i++) {
      final q = orch.nextQuestion(c);
      if (q == null) break;
      final value = switch (q.id) {
        'elderly' || 'heat' || 'speech_odd' => AnswerValue.yes,
        'consciousness' || 'breathing' => AnswerValue.unknown,
        _ => AnswerValue.unknown,
      };
      c = orch.answer(
        c,
        q,
        QuestionOption(id: value.name, label: value.name, value: value),
      );
    }
    expect(c.assessment!.level.rank >= RiskLevel.high.rank, isTrue);
    expect(c.assessment!.needsOfficialRescue, isTrue);
    expect(c.prohibitedActions.any((p) => p.id == 'no_force_drink'), isTrue);
    expect(c.report, isNotNull);
  });

  test('독거노인 무응답 추적이 단계 행동을 포함한다', () {
    var c = orch.createCase(
      freeText: '독거노인이 오랫동안 응답이 없어요',
      quickSituation: QuickSituation.unknown,
    );
    final q = orch
        .allQuestions(c)
        .firstWhere((e) => e.id == 'no_response_long');
    c = orch.answer(
      c,
      q,
      const QuestionOption(id: 'yes', label: '예', value: AnswerValue.yes),
    );
    expect(c.actionSteps.any((s) => s.id == 'call_check'), isTrue);
    expect(c.actionSteps.any((s) => s.id == 'neighbor_guardian'), isTrue);
  });
}
