import 'enums.dart';

class RiskFactor {
  const RiskFactor({
    required this.id,
    required this.label,
    required this.level,
    required this.reason,
    this.isLifeThreatSignal = false,
  });

  final String id;
  final String label;
  final RiskLevel level;
  final String reason;
  final bool isLifeThreatSignal;

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'level': level.name,
    'reason': reason,
    'isLifeThreatSignal': isLifeThreatSignal,
  };

  factory RiskFactor.fromJson(Map<String, dynamic> json) => RiskFactor(
    id: json['id'] as String,
    label: json['label'] as String,
    level: RiskLevel.values.byName(json['level'] as String),
    reason: json['reason'] as String,
    isLifeThreatSignal: json['isLifeThreatSignal'] as bool? ?? false,
  );
}

class RiskAssessment {
  const RiskAssessment({
    required this.level,
    required this.primaryRisk,
    required this.factors,
    required this.appliedRules,
    required this.needsOfficialRescue,
    required this.summary,
  });

  final RiskLevel level;
  final String primaryRisk;
  final List<RiskFactor> factors;
  final List<String> appliedRules;
  final bool needsOfficialRescue;
  final String summary;

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'primaryRisk': primaryRisk,
    'factors': factors.map((f) => f.toJson()).toList(),
    'appliedRules': appliedRules,
    'needsOfficialRescue': needsOfficialRescue,
    'summary': summary,
  };

  factory RiskAssessment.fromJson(Map<String, dynamic> json) => RiskAssessment(
    level: RiskLevel.values.byName(json['level'] as String),
    primaryRisk: json['primaryRisk'] as String,
    factors: (json['factors'] as List<dynamic>)
        .map((e) => RiskFactor.fromJson(e as Map<String, dynamic>))
        .toList(),
    appliedRules: (json['appliedRules'] as List<dynamic>).cast<String>(),
    needsOfficialRescue: json['needsOfficialRescue'] as bool,
    summary: json['summary'] as String,
  );
}
