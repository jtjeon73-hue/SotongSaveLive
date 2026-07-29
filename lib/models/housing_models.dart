class OfficialHousingSource {
  const OfficialHousingSource({
    required this.id,
    required this.agency,
    required this.title,
    required this.url,
    required this.checkedAt,
    this.note = '제도·자격·금액은 공고·연도마다 달라질 수 있습니다.',
  });

  final String id;
  final String agency;
  final String title;
  final String url;
  final String checkedAt;
  final String note;
}

class SeniorHousingType {
  const SeniorHousingType({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    required this.summary,
    required this.eligibilityOverview,
    required this.costNature,
    required this.careLevel,
    required this.medicalLevel,
    required this.advantages,
    required this.cautions,
    required this.officialSource,
    required this.checkedAt,
    this.variesByNotice = true,
    this.expertReviewRequired = true,
    this.fitSituations = const [],
    this.checkItems = const [],
  });

  final String id;
  final String slug;
  final String title;
  final String category;
  final String summary;
  final String eligibilityOverview;
  final String costNature;
  final String careLevel;
  final String medicalLevel;
  final List<String> advantages;
  final List<String> cautions;
  final OfficialHousingSource officialSource;
  final String checkedAt;
  final bool variesByNotice;
  final bool expertReviewRequired;
  final List<String> fitSituations;
  final List<String> checkItems;
}

class HousingComparison {
  const HousingComparison({
    required this.typeTitle,
    required this.independence,
    required this.mainPurpose,
    required this.careIncluded,
    required this.medicalFunction,
    required this.costNature,
    required this.eligibility,
  });

  final String typeTitle;
  final String independence;
  final String mainPurpose;
  final String careIncluded;
  final String medicalFunction;
  final String costNature;
  final String eligibility;
}

class CareStage {
  const CareStage({
    required this.id,
    required this.title,
    required this.options,
    required this.keepHomeConditions,
    required this.transitionSignals,
    required this.spouseBurden,
    required this.moneyNotes,
    required this.officialPaths,
    required this.expertChecks,
  });

  final String id;
  final String title;
  final List<String> options;
  final List<String> keepHomeConditions;
  final List<String> transitionSignals;
  final String spouseBurden;
  final String moneyNotes;
  final List<String> officialPaths;
  final List<String> expertChecks;
}

class HousingCarePath {
  const HousingCarePath({required this.stages});

  final List<CareStage> stages;
}

class FacilityChecklistSection {
  const FacilityChecklistSection({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<String> items;
}

class GovernmentHousingProgram {
  const GovernmentHousingProgram({
    required this.id,
    required this.title,
    required this.summary,
    required this.eligibilityOverview,
    required this.costNature,
    required this.careLevel,
    required this.officialSource,
    required this.checkedAt,
    this.variesByNotice = true,
    this.expertReviewRequired = true,
  });

  final String id;
  final String title;
  final String summary;
  final String eligibilityOverview;
  final String costNature;
  final String careLevel;
  final OfficialHousingSource officialSource;
  final String checkedAt;
  final bool variesByNotice;
  final bool expertReviewRequired;
}

class ChildfreeCoupleScenario {
  const ChildfreeCoupleScenario({
    required this.id,
    required this.title,
    required this.summary,
    required this.advantages,
    required this.risks,
    required this.preparations,
    required this.changeSignals,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> advantages;
  final List<String> risks;
  final List<String> preparations;
  final List<String> changeSignals;
}

class HousingSituationCard {
  const HousingSituationCard({
    required this.id,
    required this.title,
    required this.targetSectionId,
  });

  final String id;
  final String title;
  final String targetSectionId;
}
