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
    for (final profile in LifeTypesData.all) {
      if (profile.slug == slug) return profile;
    }
    return null;
  }

  static String slugOf(LifeTypeId id) {
    for (final profile in LifeTypesData.all) {
      if (profile.id == id) return profile.slug;
    }
    return id.name;
  }

  int indexOf(LifeTypeProfile profile) =>
      LifeTypesData.all.indexWhere((e) => e.id == profile.id);

  LifeTypeProfile previousCyclic(LifeTypeProfile profile) {
    final i = indexOf(profile);
    final list = LifeTypesData.all;
    if (i < 0) return list.first;
    return list[(i - 1 + list.length) % list.length];
  }

  LifeTypeProfile nextCyclic(LifeTypeProfile profile) {
    final i = indexOf(profile);
    final list = LifeTypesData.all;
    if (i < 0) return list.first;
    return list[(i + 1) % list.length];
  }

  List<({LifeTypeProfile profile, String reason})> relatedFor(
    LifeTypeProfile profile,
  ) {
    final out = <({LifeTypeProfile profile, String reason})>[];
    for (final link in profile.relatedLinks) {
      final p = byId(link.id);
      if (p != null) out.add((profile: p, reason: link.reason));
    }
    return out;
  }

  List<LifeTypeProfile> filterByCategory(LifeTypeCategory? category) {
    if (category == null) return lifeTypes;
    return lifeTypes
        .where((p) => p.categories.contains(category))
        .toList(growable: false);
  }
}
