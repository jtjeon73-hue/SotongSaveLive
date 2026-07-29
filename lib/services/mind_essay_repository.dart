import '../data/mind_essays_data.dart';
import '../models/mind_models.dart';

class MindEssayRepository {
  List<MindEssay> get all => MindEssaysData.all;

  MindEssay? bySlug(String slug) {
    for (final essay in MindEssaysData.all) {
      if (essay.slug == slug) return essay;
    }
    return null;
  }

  MindEssay? previous(String slug) {
    final index = _indexOf(slug);
    if (index == null || index <= 0) return null;
    return MindEssaysData.all[index - 1];
  }

  MindEssay? next(String slug) {
    final index = _indexOf(slug);
    if (index == null || index >= MindEssaysData.all.length - 1) {
      return null;
    }
    return MindEssaysData.all[index + 1];
  }

  List<MindEssay> related(String slug) {
    final essay = bySlug(slug);
    if (essay == null) return const [];

    final results = <MindEssay>[];
    for (final relatedSlug in essay.relatedIds) {
      final relatedEssay = bySlug(relatedSlug);
      if (relatedEssay != null) {
        results.add(relatedEssay);
      }
    }
    return results;
  }

  int? _indexOf(String slug) {
    for (var i = 0; i < MindEssaysData.all.length; i++) {
      if (MindEssaysData.all[i].slug == slug) return i;
    }
    return null;
  }
}
