import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_save_live/core/routing/app_routes.dart';
import 'package:sotong_save_live/data/legacy_data.dart';
import 'package:sotong_save_live/data/life_types_data.dart';
import 'package:sotong_save_live/data/mind_essays_data.dart';
import 'package:sotong_save_live/data/money_work_data.dart';
import 'package:sotong_save_live/data/official_sources_data.dart';
import 'package:sotong_save_live/models/life_models.dart';
import 'package:sotong_save_live/services/life_scenario_repository.dart';
import 'package:sotong_save_live/services/mind_essay_repository.dart';

void main() {
  test('상위 메뉴가 정확히 8개', () {
    expect(AppRoutes.destinations.length, 8);
  });

  test('메뉴명이 노후맞이 인생들이고 다섯 가지 인생이 없다', () {
    final labels = AppRoutes.destinations.map((e) => e.label).join('|');
    expect(labels.contains('노후맞이 인생들'), isTrue);
    expect(labels.contains('다섯 가지'), isFalse);
    expect(labels.contains('마음쉼터'), isTrue);
  });

  test('인생 유형이 최소 12개이며 slug가 고유하다', () {
    expect(LifeTypesData.all.length, greaterThanOrEqualTo(12));
    final slugs = LifeTypesData.all.map((e) => e.slug).toSet();
    expect(slugs.length, LifeTypesData.all.length);
  });

  test('신규 7개 유형이 존재한다', () {
    final ids = LifeTypesData.all.map((e) => e.id).toSet();
    expect(ids.contains(LifeTypeId.publicServant), isTrue);
    expect(ids.contains(LifeTypeId.homemakerCaregiver), isTrue);
    expect(ids.contains(LifeTypeId.soloHousehold), isTrue);
    expect(ids.contains(LifeTypeId.coupleRetirement), isTrue);
    expect(ids.contains(LifeTypeId.secondCareer), isTrue);
    expect(ids.contains(LifeTypeId.craftCreative), isTrue);
    expect(ids.contains(LifeTypeId.financiallyTight), isTrue);
  });

  test('각 유형에 필수 콘텐츠가 있다', () {
    for (final t in LifeTypesData.all) {
      expect(t.slug.isNotEmpty, isTrue, reason: t.title);
      expect(t.categories.isNotEmpty, isTrue, reason: t.title);
      expect(t.money.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.work.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.health.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.relationships.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.housing.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.risks.length, greaterThanOrEqualTo(7), reason: t.title);
      expect(t.priorities.length, greaterThanOrEqualTo(7), reason: t.title);
      expect(t.scenarios.length, 3, reason: t.title);
      expect(t.relatedLinks.length, greaterThanOrEqualTo(2), reason: t.title);
    }
  });

  test('이전·다음 인생이 순환한다', () {
    final repo = LifeScenarioRepository();
    final first = repo.lifeTypes.first;
    final last = repo.lifeTypes.last;
    expect(repo.previousCyclic(first).id, last.id);
    expect(repo.nextCyclic(last).id, first.id);
  });

  test('마음쉼터 읽을거리가 정확히 10편이고 slug가 고유하다', () {
    expect(MindEssaysData.all.length, 10);
    final slugs = MindEssaysData.all.map((e) => e.slug).toSet();
    expect(slugs.length, 10);
  });

  test('각 글에 본문·기억할 문장·성찰이 있고 관련 ID가 유효하다', () {
    final repo = MindEssayRepository();
    for (final e in MindEssaysData.all) {
      final bodyLen = e.introduction.length +
          e.sections.fold<int>(0, (a, s) => a + s.body.length);
      expect(bodyLen, greaterThanOrEqualTo(1200), reason: e.slug);
      expect(e.rememberSentence.isNotEmpty, isTrue);
      expect(e.reflection.isNotEmpty, isTrue);
      for (final id in e.relatedIds) {
        expect(repo.bySlug(id), isNotNull, reason: '${e.slug} -> $id');
      }
    }
  });

  test('금지된 자살·안락사 실행정보가 없다', () {
    final blob = MindEssaysData.all
        .map((e) => '${e.introduction}${e.sections.map((s) => s.body).join()}')
        .join();
    expect(blob.contains('자살 방법'), isFalse);
    expect(blob.contains('안락사 방법'), isFalse);
    expect(blob.contains('약물로 끝내'), isFalse);
  });

  test('출처와 가상 사례 원칙', () {
    expect(OfficialSourceRepository.sources.length, greaterThanOrEqualTo(10));
    expect(MoneyWorkData.disclaimer.contains('가상 대표 사례'), isTrue);
    expect(LegacyData.sections.any((e) => e.id == 'advance_directive'), isTrue);
  });

  test('생명구조·다섯 가지 한정 문구가 라우트에 없다', () {
    final paths = AppRoutes.destinations.map((e) => e.path).join(' ');
    expect(paths.contains('command'), isFalse);
    expect(paths.contains('assess'), isFalse);
    expect(AppRoutes.lifePaths, '/life-paths');
  });
}
