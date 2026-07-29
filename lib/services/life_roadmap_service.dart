import '../data/roadmap_data.dart';
import '../models/life_models.dart';

class LifeRoadmapService {
  List<LifeStageRoadmap> get stages => RoadmapData.stages;

  LifeStageRoadmap? byStage(LifeStageId id) {
    for (final stage in RoadmapData.stages) {
      if (stage.id == id) return stage;
    }
    return null;
  }

  RetirementScenario? scenarioByStageAndType(
    LifeStageId stageId,
    String scenarioType,
  ) {
    final stage = byStage(stageId);
    if (stage == null) return null;
    for (final scenario in stage.scenarios) {
      if (scenario.id.endsWith('_$scenarioType')) return scenario;
    }
    return null;
  }
}
