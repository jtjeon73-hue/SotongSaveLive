import 'enums.dart';

class SafetyQuestion {
  const SafetyQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    this.helpText,
    this.priority = 0,
  });

  final String id;
  final String prompt;
  final List<QuestionOption> options;
  final String? helpText;
  final int priority;
}

class QuestionOption {
  const QuestionOption({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final AnswerValue value;
}

class SituationAnswer {
  const SituationAnswer({
    required this.questionId,
    required this.optionId,
    required this.value,
    this.freeText,
    this.answeredAt,
  });

  final String questionId;
  final String optionId;
  final AnswerValue value;
  final String? freeText;
  final DateTime? answeredAt;

  SituationAnswer copyWith({
    String? questionId,
    String? optionId,
    AnswerValue? value,
    String? freeText,
    DateTime? answeredAt,
  }) {
    return SituationAnswer(
      questionId: questionId ?? this.questionId,
      optionId: optionId ?? this.optionId,
      value: value ?? this.value,
      freeText: freeText ?? this.freeText,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'optionId': optionId,
    'value': value.name,
    'freeText': freeText,
    'answeredAt': answeredAt?.toIso8601String(),
  };

  factory SituationAnswer.fromJson(Map<String, dynamic> json) =>
      SituationAnswer(
        questionId: json['questionId'] as String,
        optionId: json['optionId'] as String,
        value: AnswerValue.values.byName(json['value'] as String),
        freeText: json['freeText'] as String?,
        answeredAt: json['answeredAt'] != null
            ? DateTime.parse(json['answeredAt'] as String)
            : null,
      );
}
