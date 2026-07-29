import '../data/life_types_data.dart';
import '../data/money_work_data.dart';
import '../data/rural_life_data.dart';
import '../models/life_models.dart';
import 'life_scenario_repository.dart';

class ScenarioComparisonService {
  List<TradeOffRow> tradeOffsFor(LifeTypeId? type) {
    if (type == null) return MoneyWorkData.tradeOffs;
    final profile = _profile(type);
    return profile?.tradeOffs ?? MoneyWorkData.tradeOffs;
  }

  List<DecisionBranch> branchesFor(LifeTypeId? type) {
    if (type == null) return MoneyWorkData.branches;
    final profile = _profile(type);
    return profile?.branches ?? MoneyWorkData.branches;
  }

  List<TradeOffRow> allTradeOffs() {
    final combined = <TradeOffRow>[...MoneyWorkData.tradeOffs];
    for (final profile in LifeTypesData.all) {
      combined.addAll(profile.tradeOffs);
    }
    combined.addAll(RuralLifeData.tradeOffs);
    return combined;
  }

  List<DecisionBranch> allBranches() {
    final combined = <DecisionBranch>[...MoneyWorkData.branches];
    for (final profile in LifeTypesData.all) {
      combined.addAll(profile.branches);
    }
    combined.addAll(RuralLifeData.branches);
    return combined;
  }

  LifeTypeProfile? profileBySlug(String slug) =>
      LifeScenarioRepository().bySlug(slug);

  AiAnalysisCard? analysisFor(LifeTypeId type) => _profile(type)?.analysis;

  LifeTypeProfile? _profile(LifeTypeId type) {
    for (final profile in LifeTypesData.all) {
      if (profile.id == type) return profile;
    }
    return null;
  }
}
