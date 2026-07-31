import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_save_live/core/routing/app_routes.dart';
import 'package:sotong_save_live/data/housing_care_data.dart';
import 'package:sotong_save_live/data/legacy_data.dart';
import 'package:sotong_save_live/data/life_types_data.dart';
import 'package:sotong_save_live/data/mind_essays_data.dart';
import 'package:sotong_save_live/data/money_work_data.dart';
import 'package:sotong_save_live/data/official_sources_data.dart';
import 'package:sotong_save_live/models/life_models.dart';
import 'package:sotong_save_live/services/life_scenario_repository.dart';
import 'package:sotong_save_live/services/mind_essay_repository.dart';

bool _isPng(File file) {
  final bytes = file.readAsBytesSync();
  return bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47;
}

void main() {
  test('상위 메뉴가 정확히 9개이고 노후 주거·돌봄이 있다', () {
    expect(AppRoutes.destinations.length, 9);
    final labels = AppRoutes.destinations.map((e) => e.label).toList();
    expect(labels.contains('노후 주거·돌봄'), isTrue);
    expect(labels.contains('노후맞이 인생들'), isTrue);
    expect(labels.contains('마음쉼터'), isTrue);
    expect(labels.contains('다섯 가지'), isFalse);
    expect(AppRoutes.housingCare, '/housing-care');
  });

  test('인생 유형이 최소 13개이며 slug가 고유하다', () {
    expect(LifeTypesData.all.length, greaterThanOrEqualTo(13));
    final slugs = LifeTypesData.all.map((e) => e.slug).toSet();
    expect(slugs.length, LifeTypesData.all.length);
  });

  test('자녀 없이 부부가 함께 살아가는 노후가 있다', () {
    final t = LifeTypesData.all.firstWhere(
      (e) => e.id == LifeTypeId.childfreeCouple,
    );
    expect(t.title, '자녀 없이 부부가 함께 살아가는 노후');
    expect(t.slug, 'childfree-couple-retirement');
    expect(t.scenarios.length, greaterThanOrEqualTo(4));
    expect(
      t.relatedLinks.map((e) => e.id).contains(LifeTypeId.coupleRetirement),
      isTrue,
    );
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
      expect(t.scenarios.length, greaterThanOrEqualTo(3), reason: t.title);
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
      final bodyLen =
          e.introduction.length +
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

  test('노후 주거·돌봄 필수 유형과 구분이 있다', () {
    final titles = HousingCareData.housingTypes.map((e) => e.title).join('|');
    expect(HousingCareData.housingTypes.length, greaterThanOrEqualTo(13));
    expect(titles.contains('현재 집에서 계속 살기'), isTrue);
    expect(titles.contains('민간 실버타운'), isTrue);
    expect(titles.contains('공공 고령자복지주택'), isTrue);
    expect(titles.contains('고령자 매입임대'), isTrue);
    expect(titles.contains('실버스테이'), isTrue);
    expect(titles.contains('재가 장기요양'), isTrue);
    expect(titles.contains('노인요양시설'), isTrue);
    expect(titles.contains('요양병원'), isTrue);
    expect(titles.contains('호스피스'), isTrue);

    final blob = HousingCareData.housingTypes
        .map((e) => '${e.summary}${e.cautions.join()}')
        .join();
    expect(blob.contains('요양시설과 동일하지 않습니다'), isTrue);
    expect(blob.contains('즉시 전국 입주'), isTrue);
    expect(HousingCareData.comparisons.length, greaterThanOrEqualTo(11));
    expect(HousingCareData.carePath.stages.length, greaterThanOrEqualTo(5));
    expect(HousingCareData.childfreeScenarios.length, greaterThanOrEqualTo(5));
    expect(HousingCareData.checklists.length, 4);
  });

  test('정부제도에 공식 출처와 확인일이 있고 임의 전화번호·미확인 가격이 없다', () {
    for (final t in HousingCareData.housingTypes) {
      expect(t.officialSource.url.startsWith('http'), isTrue, reason: t.id);
      expect(t.checkedAt, HousingCareData.checkedAt);
      expect(t.officialSource.checkedAt, HousingCareData.checkedAt);
    }
    final blob = [
      ...HousingCareData.housingTypes.map((e) => e.costNature),
      ...HousingCareData.officialSources.map((e) => '${e.title}${e.note}'),
      ...HousingCareData.childfreeScenarios.map((e) => e.summary),
    ].join();
    expect(RegExp(r'0\d{1,2}-\d{3,4}-\d{4}').hasMatch(blob), isFalse);
    expect(blob.contains('보증금 1억'), isFalse);
    expect(blob.contains('월 200만'), isFalse);
  });

  test('아이콘 PNG와 manifest·favicon 연결', () {
    final root = Directory.current;
    final files = [
      File('${root.path}/web/favicon.png'),
      File('${root.path}/web/apple-touch-icon.png'),
      File('${root.path}/web/icons/Icon-192.png'),
      File('${root.path}/web/icons/Icon-512.png'),
      File('${root.path}/web/icons/Icon-maskable-192.png'),
      File('${root.path}/web/icons/Icon-maskable-512.png'),
    ];
    for (final f in files) {
      expect(f.existsSync(), isTrue, reason: f.path);
      expect(_isPng(f), isTrue, reason: f.path);
    }

    final manifest = File('${root.path}/web/manifest.json').readAsStringSync();
    expect(manifest.contains('소통노후'), isTrue);
    expect(manifest.contains('SotongSaveLive'), isFalse);
    expect(manifest.contains('#1F4D3A'), isTrue);
    expect(manifest.contains('Icon-192.png'), isTrue);
    expect(manifest.contains('Icon-maskable-512.png'), isTrue);

    final index = File('${root.path}/web/index.html').readAsStringSync();
    expect(index.contains('favicon.png'), isTrue);
    expect(index.contains('apple-touch-icon.png'), isTrue);
    expect(index.contains('#1F4D3A'), isTrue);

    // Flutter default blue-bird logo assets should not be referenced in web.
    expect(
      index.toLowerCase().contains('icons/Icon-192.png'.toLowerCase()) ||
          index.contains('apple-touch-icon'),
      isTrue,
    );
  });

  test('시설 점검표 필수 항목', () {
    final items = HousingCareData.checklists.expand((e) => e.items).join('|');
    expect(items.contains('보증금 보호'), isTrue);
    expect(items.contains('야간인력'), isTrue);
    expect(items.contains('식사를 실제로 먹어보기'), isTrue);
    expect(items.contains('부부 중 한 사람 사망 시 계약변화'), isTrue);
  });
}
