class SafetyProfile {
  SafetyProfile({
    this.ageBand = '',
    this.healthNotes = const [],
    this.allergies = '',
    this.hasMedications = false,
    this.mobilityLimit = false,
    this.hearingLimit = false,
    this.visionLimit = false,
    this.guardianOrder = '',
    this.frequentPlaces = '',
    this.farmOrFactory = false,
    this.mountainActivity = false,
    this.hasVehicle = false,
    this.householdNotes = '',
    this.pets = '',
    this.emergencyNeeds = '',
    this.consentGiven = false,
    this.updatedAt,
  });

  String ageBand;
  List<String> healthNotes;
  String allergies;
  bool hasMedications;
  bool mobilityLimit;
  bool hearingLimit;
  bool visionLimit;
  String guardianOrder;
  String frequentPlaces;
  bool farmOrFactory;
  bool mountainActivity;
  bool hasVehicle;
  String householdNotes;
  String pets;
  String emergencyNeeds;
  bool consentGiven;
  DateTime? updatedAt;

  bool get hasAnyData =>
      ageBand.isNotEmpty ||
      healthNotes.isNotEmpty ||
      allergies.isNotEmpty ||
      hasMedications ||
      mobilityLimit ||
      hearingLimit ||
      visionLimit ||
      guardianOrder.isNotEmpty ||
      frequentPlaces.isNotEmpty ||
      farmOrFactory ||
      mountainActivity ||
      hasVehicle ||
      householdNotes.isNotEmpty ||
      pets.isNotEmpty ||
      emergencyNeeds.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'ageBand': ageBand,
    'healthNotes': healthNotes,
    'allergies': allergies,
    'hasMedications': hasMedications,
    'mobilityLimit': mobilityLimit,
    'hearingLimit': hearingLimit,
    'visionLimit': visionLimit,
    'guardianOrder': guardianOrder,
    'frequentPlaces': frequentPlaces,
    'farmOrFactory': farmOrFactory,
    'mountainActivity': mountainActivity,
    'hasVehicle': hasVehicle,
    'householdNotes': householdNotes,
    'pets': pets,
    'emergencyNeeds': emergencyNeeds,
    'consentGiven': consentGiven,
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory SafetyProfile.fromJson(Map<String, dynamic> json) => SafetyProfile(
    ageBand: json['ageBand'] as String? ?? '',
    healthNotes: (json['healthNotes'] as List<dynamic>? ?? []).cast<String>(),
    allergies: json['allergies'] as String? ?? '',
    hasMedications: json['hasMedications'] as bool? ?? false,
    mobilityLimit: json['mobilityLimit'] as bool? ?? false,
    hearingLimit: json['hearingLimit'] as bool? ?? false,
    visionLimit: json['visionLimit'] as bool? ?? false,
    guardianOrder: json['guardianOrder'] as String? ?? '',
    frequentPlaces: json['frequentPlaces'] as String? ?? '',
    farmOrFactory: json['farmOrFactory'] as bool? ?? false,
    mountainActivity: json['mountainActivity'] as bool? ?? false,
    hasVehicle: json['hasVehicle'] as bool? ?? false,
    householdNotes: json['householdNotes'] as String? ?? '',
    pets: json['pets'] as String? ?? '',
    emergencyNeeds: json['emergencyNeeds'] as String? ?? '',
    consentGiven: json['consentGiven'] as bool? ?? false,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
  );
}

class FamilyMemberCard {
  FamilyMemberCard({
    required this.id,
    required this.name,
    this.relation = '',
    this.notes = '',
    this.usualPattern = '',
    this.lastCheckAt,
    this.medicationsNote = '',
    this.allergyNote = '',
    this.mobilityNote = '',
    this.contactOrder = '',
  });

  final String id;
  String name;
  String relation;
  String notes;
  String usualPattern;
  DateTime? lastCheckAt;
  String medicationsNote;
  String allergyNote;
  String mobilityNote;
  String contactOrder;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relation': relation,
    'notes': notes,
    'usualPattern': usualPattern,
    'lastCheckAt': lastCheckAt?.toIso8601String(),
    'medicationsNote': medicationsNote,
    'allergyNote': allergyNote,
    'mobilityNote': mobilityNote,
    'contactOrder': contactOrder,
  };

  factory FamilyMemberCard.fromJson(Map<String, dynamic> json) =>
      FamilyMemberCard(
        id: json['id'] as String,
        name: json['name'] as String,
        relation: json['relation'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
        usualPattern: json['usualPattern'] as String? ?? '',
        lastCheckAt: json['lastCheckAt'] != null
            ? DateTime.parse(json['lastCheckAt'] as String)
            : null,
        medicationsNote: json['medicationsNote'] as String? ?? '',
        allergyNote: json['allergyNote'] as String? ?? '',
        mobilityNote: json['mobilityNote'] as String? ?? '',
        contactOrder: json['contactOrder'] as String? ?? '',
      );
}

class SensorSnapshot {
  const SensorSnapshot({
    this.usualActivityStartHour = 7,
    this.lastMotionMinutesAgo = 30,
    this.temperatureC = 24,
    this.smokeSensor = 0,
    this.gasSensor = 0,
    this.equipmentCurrent = 10,
    this.usualCurrent = 10,
    this.workerInHazardZone = false,
    this.riverLevelDeltaCm = 0,
    this.locationStationaryMinutes = 0,
  });

  final int usualActivityStartHour;
  final int lastMotionMinutesAgo;
  final double temperatureC;
  final double smokeSensor;
  final double gasSensor;
  final double equipmentCurrent;
  final double usualCurrent;
  final bool workerInHazardZone;
  final double riverLevelDeltaCm;
  final int locationStationaryMinutes;

  SensorSnapshot copyWith({
    int? usualActivityStartHour,
    int? lastMotionMinutesAgo,
    double? temperatureC,
    double? smokeSensor,
    double? gasSensor,
    double? equipmentCurrent,
    double? usualCurrent,
    bool? workerInHazardZone,
    double? riverLevelDeltaCm,
    int? locationStationaryMinutes,
  }) {
    return SensorSnapshot(
      usualActivityStartHour:
          usualActivityStartHour ?? this.usualActivityStartHour,
      lastMotionMinutesAgo: lastMotionMinutesAgo ?? this.lastMotionMinutesAgo,
      temperatureC: temperatureC ?? this.temperatureC,
      smokeSensor: smokeSensor ?? this.smokeSensor,
      gasSensor: gasSensor ?? this.gasSensor,
      equipmentCurrent: equipmentCurrent ?? this.equipmentCurrent,
      usualCurrent: usualCurrent ?? this.usualCurrent,
      workerInHazardZone: workerInHazardZone ?? this.workerInHazardZone,
      riverLevelDeltaCm: riverLevelDeltaCm ?? this.riverLevelDeltaCm,
      locationStationaryMinutes:
          locationStationaryMinutes ?? this.locationStationaryMinutes,
    );
  }
}

class PredictionResult {
  const PredictionResult({
    required this.levelLabel,
    required this.domain,
    required this.reasons,
    required this.recommendedAction,
  });

  final String levelLabel;
  final String domain;
  final List<String> reasons;
  final String recommendedAction;
}

class OfficialSourceMeta {
  const OfficialSourceMeta({
    required this.agency,
    required this.documentTitle,
    this.url,
    this.publishedAt,
    this.reviewedAt,
    this.audience = '일반',
    this.reviewStatus = '전문 검토 필요',
    this.needsExpertReview = true,
  });

  final String agency;
  final String documentTitle;
  final String? url;
  final String? publishedAt;
  final String? reviewedAt;
  final String audience;
  final String reviewStatus;
  final bool needsExpertReview;
}
