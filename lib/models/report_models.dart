class SituationReport {
  const SituationReport({
    required this.headline,
    required this.fullText,
    required this.guardianSummary,
    required this.rescueSummary,
    required this.fields,
    this.includesPersonalInfo = false,
  });

  final String headline;
  final String fullText;
  final String guardianSummary;
  final String rescueSummary;
  final Map<String, String> fields;
  final bool includesPersonalInfo;

  Map<String, dynamic> toJson() => {
    'headline': headline,
    'fullText': fullText,
    'guardianSummary': guardianSummary,
    'rescueSummary': rescueSummary,
    'fields': fields,
    'includesPersonalInfo': includesPersonalInfo,
  };

  factory SituationReport.fromJson(Map<String, dynamic> json) =>
      SituationReport(
        headline: json['headline'] as String,
        fullText: json['fullText'] as String,
        guardianSummary: json['guardianSummary'] as String,
        rescueSummary: json['rescueSummary'] as String,
        fields: Map<String, String>.from(json['fields'] as Map),
        includesPersonalInfo: json['includesPersonalInfo'] as bool? ?? false,
      );
}

class FollowUpCheck {
  const FollowUpCheck({
    required this.id,
    required this.prompt,
    required this.completed,
    this.note,
  });

  final String id;
  final String prompt;
  final bool completed;
  final String? note;

  FollowUpCheck copyWith({bool? completed, String? note}) {
    return FollowUpCheck(
      id: id,
      prompt: prompt,
      completed: completed ?? this.completed,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'prompt': prompt,
    'completed': completed,
    'note': note,
  };

  factory FollowUpCheck.fromJson(Map<String, dynamic> json) => FollowUpCheck(
    id: json['id'] as String,
    prompt: json['prompt'] as String,
    completed: json['completed'] as bool,
    note: json['note'] as String?,
  );
}

class PreventionPlan {
  const PreventionPlan({
    required this.summary,
    required this.whatWentWell,
    required this.unknownGaps,
    required this.equipmentToPrepare,
    required this.shareWithFamily,
    required this.facilityImprovements,
    required this.followUpChecks,
  });

  final String summary;
  final List<String> whatWentWell;
  final List<String> unknownGaps;
  final List<String> equipmentToPrepare;
  final List<String> shareWithFamily;
  final List<String> facilityImprovements;
  final List<String> followUpChecks;

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'whatWentWell': whatWentWell,
    'unknownGaps': unknownGaps,
    'equipmentToPrepare': equipmentToPrepare,
    'shareWithFamily': shareWithFamily,
    'facilityImprovements': facilityImprovements,
    'followUpChecks': followUpChecks,
  };
}
