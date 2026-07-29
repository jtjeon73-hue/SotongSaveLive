enum LifeTypeId {
  employeeRetiree,
  alreadyRetired,
  freelancer,
  businessOwner,
  ruralLife,
}

enum LifeStageId { forties, fifties, sixties, seventies, eightiesPlus }

enum LifeDomainId {
  cashflow,
  meaningfulWork,
  mobilityHealth,
  relationships,
  housing,
  growthJoy,
  dignifiedEnding,
}

class OfficialSource {
  const OfficialSource({
    required this.id,
    required this.agency,
    required this.title,
    required this.url,
    required this.checkedOn,
    this.note = '제도·금액은 변경될 수 있습니다.',
    this.needsExpertReview = true,
  });

  final String id;
  final String agency;
  final String title;
  final String url;
  final String checkedOn;
  final String note;
  final bool needsExpertReview;
}

class TradeOffRow {
  const TradeOffRow({
    required this.choice,
    required this.shortTerm,
    required this.fiveYear,
    required this.tenYear,
    required this.caution,
  });

  final String choice;
  final String shortTerm;
  final String fiveYear;
  final String tenYear;
  final String caution;
}

class DecisionBranch {
  const DecisionBranch({
    required this.trigger,
    required this.steps,
    required this.why,
    required this.nextAction,
  });

  final String trigger;
  final List<String> steps;
  final String why;
  final String nextAction;
}

class RetirementScenario {
  const RetirementScenario({
    required this.id,
    required this.title,
    required this.situation,
    required this.firstChanges,
    required this.easyToMissRisks,
    required this.preparedVsUnprepared,
    required this.responseOrder,
    required this.recoveryPath,
  });

  final String id;
  final String title;
  final String situation;
  final String firstChanges;
  final List<String> easyToMissRisks;
  final String preparedVsUnprepared;
  final List<String> responseOrder;
  final String recoveryPath;
}

class AiAnalysisCard {
  const AiAnalysisCard({
    required this.strengths,
    required this.growingRisks,
    required this.easyToMiss,
    required this.paths,
    required this.pathTradeoffs,
    required this.prepareBeforeLate,
    required this.decideWithSpouse,
    required this.needsExpertCheck,
  });

  final List<String> strengths;
  final List<String> growingRisks;
  final List<String> easyToMiss;
  final List<String> paths;
  final List<String> pathTradeoffs;
  final List<String> prepareBeforeLate;
  final List<String> decideWithSpouse;
  final List<String> needsExpertCheck;
}

class LifeTypeProfile {
  const LifeTypeProfile({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.traits,
    required this.biggestStrength,
    required this.easiestMissedRisk,
    required this.stageChanges,
    required this.money,
    required this.work,
    required this.health,
    required this.relationships,
    required this.housing,
    required this.family,
    required this.crisisAlternatives,
    required this.tenYearStrategy,
    required this.forkGood,
    required this.forkHard,
    required this.coreFive,
    required this.risks,
    required this.priorities,
    required this.scenarios,
    required this.tradeOffs,
    required this.branches,
    required this.analysis,
  });

  final LifeTypeId id;
  final String title;
  final String subtitle;
  final List<String> traits;
  final String biggestStrength;
  final String easiestMissedRisk;
  final Map<LifeStageId, String> stageChanges;
  final List<String> money;
  final List<String> work;
  final List<String> health;
  final List<String> relationships;
  final List<String> housing;
  final List<String> family;
  final List<String> crisisAlternatives;
  final List<String> tenYearStrategy;
  final String forkGood;
  final String forkHard;
  final List<String> coreFive;
  final List<String> risks;
  final List<String> priorities;
  final List<RetirementScenario> scenarios;
  final List<TradeOffRow> tradeOffs;
  final List<DecisionBranch> branches;
  final AiAnalysisCard analysis;
}

class LifeStageRoadmap {
  const LifeStageRoadmap({
    required this.id,
    required this.title,
    required this.focus,
    required this.items,
    required this.scenarios,
  });

  final LifeStageId id;
  final String title;
  final String focus;
  final List<String> items;
  final List<RetirementScenario> scenarios;
}

class RuralLifeScenario {
  const RuralLifeScenario({
    required this.title,
    required this.pros,
    required this.risks,
    required this.neededPrep,
    required this.reduceFailureOrder,
  });

  final String title;
  final List<String> pros;
  final List<String> risks;
  final List<String> neededPrep;
  final List<String> reduceFailureOrder;
}

class LegacySection {
  const LegacySection({
    required this.id,
    required this.title,
    required this.summary,
    required this.points,
    this.legalNote,
    this.sourceIds = const [],
  });

  final String id;
  final String title;
  final String summary;
  final List<String> points;
  final String? legalNote;
  final List<String> sourceIds;
}
