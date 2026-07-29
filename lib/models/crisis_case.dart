import 'action_models.dart';
import 'enums.dart';
import 'question_models.dart';
import 'report_models.dart';
import 'risk_models.dart';

class CrisisCase {
  CrisisCase({
    required this.id,
    required this.createdAt,
    this.freeText = '',
    this.quickSituation,
    this.subjectType = SubjectType.self,
    this.aloneStatus = AloneStatus.unknown,
    this.locationText = '',
    this.answers = const {},
    this.assessment,
    this.actionSteps = const [],
    this.prohibitedActions = const [],
    this.report,
    this.followUps = const [],
    this.startedAt,
    this.rescueRequested = false,
    this.guardianContacted = false,
    this.isWitnessMode = false,
    this.isClosed = false,
    this.timeline = const [],
  });

  final String id;
  final DateTime createdAt;
  String freeText;
  QuickSituation? quickSituation;
  SubjectType subjectType;
  AloneStatus aloneStatus;
  String locationText;
  Map<String, SituationAnswer> answers;
  RiskAssessment? assessment;
  List<ActionStep> actionSteps;
  List<ProhibitedAction> prohibitedActions;
  SituationReport? report;
  List<FollowUpCheck> followUps;
  DateTime? startedAt;
  bool rescueRequested;
  bool guardianContacted;
  bool isWitnessMode;
  bool isClosed;
  List<TimelineEvent> timeline;

  CrisisCase copy() {
    return CrisisCase(
      id: id,
      createdAt: createdAt,
      freeText: freeText,
      quickSituation: quickSituation,
      subjectType: subjectType,
      aloneStatus: aloneStatus,
      locationText: locationText,
      answers: Map<String, SituationAnswer>.from(answers),
      assessment: assessment,
      actionSteps: List<ActionStep>.from(actionSteps),
      prohibitedActions: List<ProhibitedAction>.from(prohibitedActions),
      report: report,
      followUps: List<FollowUpCheck>.from(followUps),
      startedAt: startedAt,
      rescueRequested: rescueRequested,
      guardianContacted: guardianContacted,
      isWitnessMode: isWitnessMode,
      isClosed: isClosed,
      timeline: List<TimelineEvent>.from(timeline),
    );
  }

  AnswerValue? answerOf(String questionId) => answers[questionId]?.value;

  bool hasAnswer(String questionId) => answers.containsKey(questionId);

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'freeText': freeText,
    'quickSituation': quickSituation?.name,
    'subjectType': subjectType.name,
    'aloneStatus': aloneStatus.name,
    'locationText': locationText,
    'answers': answers.map((k, v) => MapEntry(k, v.toJson())),
    'assessment': assessment?.toJson(),
    'actionSteps': actionSteps.map((e) => e.toJson()).toList(),
    'prohibitedActions': prohibitedActions.map((e) => e.toJson()).toList(),
    'report': report?.toJson(),
    'followUps': followUps.map((e) => e.toJson()).toList(),
    'startedAt': startedAt?.toIso8601String(),
    'rescueRequested': rescueRequested,
    'guardianContacted': guardianContacted,
    'isWitnessMode': isWitnessMode,
    'isClosed': isClosed,
    'timeline': timeline.map((e) => e.toJson()).toList(),
  };

  factory CrisisCase.fromJson(Map<String, dynamic> json) {
    final answersRaw = json['answers'] as Map<String, dynamic>? ?? {};
    return CrisisCase(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      freeText: json['freeText'] as String? ?? '',
      quickSituation: json['quickSituation'] != null
          ? QuickSituation.values.byName(json['quickSituation'] as String)
          : null,
      subjectType: SubjectType.values.byName(
        json['subjectType'] as String? ?? 'self',
      ),
      aloneStatus: AloneStatus.values.byName(
        json['aloneStatus'] as String? ?? 'unknown',
      ),
      locationText: json['locationText'] as String? ?? '',
      answers: answersRaw.map(
        (k, v) =>
            MapEntry(k, SituationAnswer.fromJson(v as Map<String, dynamic>)),
      ),
      assessment: json['assessment'] != null
          ? RiskAssessment.fromJson(json['assessment'] as Map<String, dynamic>)
          : null,
      actionSteps: (json['actionSteps'] as List<dynamic>? ?? [])
          .map((e) => ActionStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      prohibitedActions: (json['prohibitedActions'] as List<dynamic>? ?? [])
          .map((e) => ProhibitedAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      report: json['report'] != null
          ? SituationReport.fromJson(json['report'] as Map<String, dynamic>)
          : null,
      followUps: (json['followUps'] as List<dynamic>? ?? [])
          .map((e) => FollowUpCheck.fromJson(e as Map<String, dynamic>))
          .toList(),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      rescueRequested: json['rescueRequested'] as bool? ?? false,
      guardianContacted: json['guardianContacted'] as bool? ?? false,
      isWitnessMode: json['isWitnessMode'] as bool? ?? false,
      isClosed: json['isClosed'] as bool? ?? false,
      timeline: (json['timeline'] as List<dynamic>? ?? [])
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TimelineEvent {
  const TimelineEvent({required this.at, required this.label, this.detail});

  final DateTime at;
  final String label;
  final String? detail;

  Map<String, dynamic> toJson() => {
    'at': at.toIso8601String(),
    'label': label,
    'detail': detail,
  };

  factory TimelineEvent.fromJson(Map<String, dynamic> json) => TimelineEvent(
    at: DateTime.parse(json['at'] as String),
    label: json['label'] as String,
    detail: json['detail'] as String?,
  );
}
