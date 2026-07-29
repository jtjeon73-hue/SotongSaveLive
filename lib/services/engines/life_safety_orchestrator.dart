import 'package:uuid/uuid.dart';

import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/question_models.dart';
import '../../models/report_models.dart';
import 'action_plan_engine.dart';
import 'follow_up_engine.dart';
import 'prevention_plan_engine.dart';
import 'risk_assessment_engine.dart';
import 'safety_report_generator.dart';
import 'situation_question_engine.dart';

class LifeSafetyOrchestrator {
  LifeSafetyOrchestrator({
    RiskAssessmentEngine? riskEngine,
    SituationQuestionEngine? questionEngine,
    ActionPlanEngine? actionEngine,
    SafetyReportGenerator? reportGenerator,
    FollowUpEngine? followUpEngine,
    PreventionPlanEngine? preventionEngine,
  }) : _risk = riskEngine ?? RiskAssessmentEngine(),
       _questions = questionEngine ?? SituationQuestionEngine(),
       _actions = actionEngine ?? ActionPlanEngine(),
       _reports = reportGenerator ?? SafetyReportGenerator(),
       _followUps = followUpEngine ?? FollowUpEngine(),
       _prevention = preventionEngine ?? PreventionPlanEngine();

  final RiskAssessmentEngine _risk;
  final SituationQuestionEngine _questions;
  final ActionPlanEngine _actions;
  final SafetyReportGenerator _reports;
  final FollowUpEngine _followUps;
  final PreventionPlanEngine _prevention;
  final _uuid = const Uuid();

  CrisisCase createCase({
    String freeText = '',
    QuickSituation? quickSituation,
    SubjectType subjectType = SubjectType.self,
    AloneStatus aloneStatus = AloneStatus.unknown,
    String locationText = '',
    bool isWitnessMode = false,
  }) {
    final crisis = CrisisCase(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      freeText: freeText,
      quickSituation: quickSituation,
      subjectType: subjectType,
      aloneStatus: aloneStatus,
      locationText: locationText,
      isWitnessMode: isWitnessMode,
      startedAt: DateTime.now(),
      timeline: [
        TimelineEvent(
          at: DateTime.now(),
          label: '사건 시작',
          detail: quickSituation?.labelKo ?? freeText,
        ),
      ],
    );
    return recompute(crisis);
  }

  CrisisCase answer(
    CrisisCase crisis,
    SafetyQuestion question,
    QuestionOption option,
  ) {
    final updated = crisis.copy();
    updated.answers[question.id] = SituationAnswer(
      questionId: question.id,
      optionId: option.id,
      value: option.value,
      answeredAt: DateTime.now(),
    );
    updated.timeline = [
      ...updated.timeline,
      TimelineEvent(
        at: DateTime.now(),
        label: '답변',
        detail: '${question.prompt} → ${option.label}',
      ),
    ];
    return recompute(updated);
  }

  CrisisCase updateAnswer(
    CrisisCase crisis,
    String questionId,
    QuestionOption option,
  ) {
    final updated = crisis.copy();
    updated.answers[questionId] = SituationAnswer(
      questionId: questionId,
      optionId: option.id,
      value: option.value,
      answeredAt: DateTime.now(),
    );
    updated.timeline = [
      ...updated.timeline,
      TimelineEvent(
        at: DateTime.now(),
        label: '답변 수정',
        detail: '$questionId → ${option.label}',
      ),
    ];
    return recompute(updated);
  }

  CrisisCase recompute(CrisisCase crisis) {
    final updated = crisis.copy();
    final assessment = _risk.assess(updated);
    final plan = _actions.build(updated, assessment);
    final previousStatus = {
      for (final step in updated.actionSteps) step.id: step.status,
    };
    updated.assessment = assessment;
    updated.actionSteps = plan.steps
        .map((s) => s.copyWith(status: previousStatus[s.id] ?? s.status))
        .toList();
    updated.prohibitedActions = plan.prohibited;
    updated.report = _reports.generate(updated, assessment);
    updated.followUps = _followUps.build(updated, assessment);
    return updated;
  }

  SafetyQuestion? nextQuestion(CrisisCase crisis) =>
      _questions.nextQuestion(crisis);

  List<SafetyQuestion> allQuestions(CrisisCase crisis) =>
      _questions.allQuestions(crisis);

  CrisisCase markAction(CrisisCase crisis, String stepId, ActionStatus status) {
    final updated = crisis.copy();
    updated.actionSteps = updated.actionSteps
        .map((s) => s.id == stepId ? s.copyWith(status: status) : s)
        .toList();
    updated.timeline = [
      ...updated.timeline,
      TimelineEvent(
        at: DateTime.now(),
        label: '행동 상태',
        detail: '$stepId → ${status.name}',
      ),
    ];
    return updated;
  }

  CrisisCase setFlags(
    CrisisCase crisis, {
    bool? rescueRequested,
    bool? guardianContacted,
  }) {
    final updated = crisis.copy();
    if (rescueRequested != null) updated.rescueRequested = rescueRequested;
    if (guardianContacted != null) {
      updated.guardianContacted = guardianContacted;
    }
    return recompute(updated);
  }

  PreventionPlan closeCase(CrisisCase crisis) {
    final assessment = crisis.assessment ?? _risk.assess(crisis);
    return _prevention.build(crisis, assessment);
  }

  /// Detects non-empathetic / diagnostic language for mental crisis outputs.
  bool containsUnsafeMentalLanguage(String text) {
    const banned = [
      '네가 잘못',
      '정신병',
      '너는 환자',
      '틀림없이 우울',
      '자살할 것이다',
      '바보 같은',
      '과장하는',
    ];
    return banned.any(text.contains);
  }

  /// Ensures we never invent phone numbers or fake agencies.
  bool containsInventedContact(String text) {
    final phoneLike = RegExp(r'0\d{1,2}-\d{3,4}-\d{4}');
    // Stage-1 policy: no generated phone numbers at all.
    if (phoneLike.hasMatch(text)) return true;
    const fakeAgencies = ['가상긴급센터', '임의상담소', '가짜구조대'];
    return fakeAgencies.any(text.contains);
  }
}
