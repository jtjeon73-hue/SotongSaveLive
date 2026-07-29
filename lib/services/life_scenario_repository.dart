import '../data/life_types_data.dart';
import '../models/life_models.dart';

class LifeScenarioRepository {
  List<LifeTypeProfile> get lifeTypes => LifeTypesData.all;

  LifeTypeProfile? byId(LifeTypeId id) {
    for (final profile in LifeTypesData.all) {
      if (profile.id == id) return profile;
    }
    return null;
  }

  LifeTypeProfile? bySlug(String slug) {
    for (final entry in _slugToId.entries) {
      if (entry.key == slug) return byId(entry.value);
    }
    return null;
  }

  static String slugOf(LifeTypeId id) {
    return _idToSlug[id] ?? id.name;
  }

  static LifeTypeId? idFromSlug(String slug) => _slugToId[slug];

  static const _idToSlug = <LifeTypeId, String>{
    LifeTypeId.employeeRetiree: 'employee-retiree',
    LifeTypeId.alreadyRetired: 'already-retired',
    LifeTypeId.freelancer: 'freelancer',
    LifeTypeId.businessOwner: 'business-owner',
    LifeTypeId.ruralLife: 'rural-life',
  };

  static const _slugToId = <String, LifeTypeId>{
    'employee-retiree': LifeTypeId.employeeRetiree,
    'already-retired': LifeTypeId.alreadyRetired,
    'freelancer': LifeTypeId.freelancer,
    'business-owner': LifeTypeId.businessOwner,
    'rural-life': LifeTypeId.ruralLife,
  };
}
