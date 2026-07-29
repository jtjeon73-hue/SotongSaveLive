import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_save_live/core/routing/app_routes.dart';
import 'package:sotong_save_live/data/legacy_data.dart';
import 'package:sotong_save_live/data/life_types_data.dart';
import 'package:sotong_save_live/data/money_work_data.dart';
import 'package:sotong_save_live/data/official_sources_data.dart';
import 'package:sotong_save_live/data/rural_life_data.dart';
import 'package:sotong_save_live/models/life_models.dart';
import 'package:sotong_save_live/services/life_roadmap_service.dart';
import 'package:sotong_save_live/services/life_scenario_repository.dart';

void main() {
  test('인생 유형이 정확히 5개', () {
    expect(LifeTypesData.all.length, 5);
    expect(LifeTypesData.all.map((e) => e.id).toSet(), {
      LifeTypeId.employeeRetiree,
      LifeTypeId.alreadyRetired,
      LifeTypeId.freelancer,
      LifeTypeId.businessOwner,
      LifeTypeId.ruralLife,
    });
  });

  test('상위 메뉴가 7개', () {
    expect(AppRoutes.destinations.length, 7);
  });

  test('각 유형에 연령대 전략·돈·일·건강·관계·주거가 있다', () {
    for (final t in LifeTypesData.all) {
      expect(t.stageChanges.isNotEmpty, isTrue, reason: t.title);
      expect(t.money.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.work.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.health.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.relationships.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.housing.length, greaterThanOrEqualTo(5), reason: t.title);
      expect(t.risks.length, greaterThanOrEqualTo(7), reason: t.title);
      expect(t.priorities.length, greaterThanOrEqualTo(7), reason: t.title);
      expect(t.scenarios.length, 3, reason: t.title);
      expect(t.coreFive.length, 5, reason: t.title);
    }
  });

  test('출처 URL과 기준일이 존재한다', () {
    expect(OfficialSourceRepository.sources.length, greaterThanOrEqualTo(10));
    for (final s in OfficialSourceRepository.sources) {
      expect(s.url.startsWith('http'), isTrue, reason: s.agency);
      expect(s.checkedOn.isNotEmpty, isTrue);
    }
  });

  test('생명구조 라우트·문구가 남아 있지 않다', () {
    final paths = AppRoutes.destinations.map((e) => e.path).join(' ');
    expect(paths.contains('command'), isFalse);
    expect(paths.contains('assess'), isFalse);
    expect(paths.contains('witness'), isFalse);
    final labels = AppRoutes.destinations.map((e) => e.label).join(' ');
    expect(labels.contains('지휘'), isFalse);
    expect(labels.contains('상황판단'), isFalse);
  });

  test('사전연명의료의향서 내용이 공식 요건을 반영한다', () {
    final section = LegacyData.sections.firstWhere(
      (e) => e.id == 'advance_directive',
    );
    final blob = '${section.summary}\n${section.points.join('\n')}';
    expect(blob.contains('19세'), isTrue);
    expect(blob.contains('등록기관'), isTrue);
    expect(blob.contains('법적 효력'), isTrue);
    expect(blob.contains('변경') || blob.contains('철회'), isTrue);
    expect(blob.toLowerCase().contains('lst.go.kr'), isTrue);
    expect(section.sourceIds.contains('lst'), isTrue);
    expect(blob.contains('이 사이트에서 작성'), isFalse);
  });

  test('가상 금액이 실제 제도 금액처럼 단정되지 않는다', () {
    expect(MoneyWorkData.disclaimer.contains('가상 대표 사례'), isTrue);
    final moneyBlob = MoneyWorkData.moneyTopics
        .map((e) => '${e.$1}${e.$2.join()}')
        .join();
    expect(moneyBlob.contains('가상 대표 사례'), isTrue);
  });

  test('농촌 시나리오가 5개', () {
    expect(RuralLifeData.scenarios.length, 5);
  });

  test('아름다운 마무리 영역이 8개 이상', () {
    expect(LegacyData.sections.length, greaterThanOrEqualTo(8));
  });

  test('로드맵 연령대가 5개이며 시나리오가 있다', () {
    final stages = LifeRoadmapService().stages;
    expect(stages.length, 5);
    for (final s in stages) {
      expect(s.items.length, greaterThanOrEqualTo(7));
      expect(s.scenarios.length, 3);
    }
  });

  test('슬러그로 유형을 찾을 수 있다', () {
    final repo = LifeScenarioRepository();
    expect(repo.bySlug('employee-retiree')?.id, LifeTypeId.employeeRetiree);
    expect(repo.bySlug('rural-life')?.id, LifeTypeId.ruralLife);
  });
}
