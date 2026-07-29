import '../data/official_sources_data.dart';
import '../models/life_models.dart';

export '../data/official_sources_data.dart';

/// 공식 출처 접근을 위한 서비스 레이어.
/// 데이터는 [OfficialSourceRepository]에 정의되어 있습니다.
class OfficialSourcesService {
  const OfficialSourcesService();

  /// [OfficialSourceRepository.sources]와 동일.
  List<OfficialSource> get all => OfficialSourceRepository.sources;

  OfficialSource? byId(String id) => OfficialSourceRepository.byId(id);

  List<OfficialSource> byIds(Iterable<String> ids) {
    final result = <OfficialSource>[];
    for (final id in ids) {
      final source = byId(id);
      if (source != null) result.add(source);
    }
    return result;
  }
}
