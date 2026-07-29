import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/report_models.dart';
import '../../models/risk_models.dart';

class PreventionPlanEngine {
  PreventionPlan build(CrisisCase crisis, RiskAssessment assessment) {
    final completed = crisis.actionSteps.where(
      (s) => s.status == ActionStatus.completed,
    );
    final unknownAnswers = crisis.answers.entries
        .where((e) => e.value.value == AnswerValue.unknown)
        .map((e) => e.key)
        .toList();

    final equipment = <String>['손전등·비상연락망 확인', '응급 상황 전달문 템플릿 보관'];
    final facility = <String>[];
    final share = <String>[
      '이번 사건에서 확인된 우선 위험: ${assessment.primaryRisk}',
      '보호자 연락 순서 재확인',
    ];

    switch (crisis.quickSituation) {
      case QuickSituation.personCollapsed:
        equipment.addAll(['그늘막·냉각용품', '폭염 작업 시 휴식 계획']);
        facility.add('밭·야외 작업 중 안부 확인 주기 설정');
      case QuickSituation.trafficOrMachineAccident:
        equipment.add('기계 비상정지·전원차단 위치 표시');
        facility.addAll(['끼임 방지 가드 점검', '작업자 무응답 감지 센서 검토']);
      case QuickSituation.fireOrSmoke:
        equipment.add('대피 경로·집합 장소 사전 공유');
        facility.add('연기·화재 센서 및 산불 감시 연계 검토');
      case QuickSituation.mentalCrisis:
        share.add('혼자 두지 않기 위한 연락 약속');
        equipment.add('신뢰하는 사람 연락 방법 정리');
      case QuickSituation.livingCollapse:
        share.add('오늘 밤 안전 장소와 지원 준비목록 공유');
      default:
        break;
    }

    if (crisis.answerOf('no_response_long') == AnswerValue.yes) {
      facility.add('고령자 무활동·안부 확인 스케줄 및 센서 연동 검토');
    }

    return PreventionPlan(
      summary:
          '${assessment.level.labelKo} 위험 상황을 종료했습니다. 재발을 줄이기 위한 점검이 필요합니다.',
      whatWentWell: [
        if (completed.isNotEmpty)
          '수행한 행동: ${completed.map((e) => e.title).join(', ')}',
        if (crisis.rescueRequested) '공식 도움 요청을 진행함',
        if (crisis.guardianContacted) '보호자 연락을 진행함',
        '확인된 사실을 기준으로 전달문을 정리함',
      ],
      unknownGaps: [
        if (unknownAnswers.isNotEmpty)
          '확인하지 못한 항목: ${unknownAnswers.join(', ')}',
        '확인 불가는 안전으로 보지 말고 추후 보완하세요.',
      ],
      equipmentToPrepare: equipment,
      shareWithFamily: share,
      facilityImprovements: facility.isEmpty
          ? ['필요 시 센서·PLC·안부확인 연동을 2단계에서 검토']
          : facility,
      followUpChecks: [
        '후속 전문기관 확인이 필요한지 점검',
        '가족·관리자와 사건 요약 공유',
        '월간 안전점검 항목에 반영',
      ],
    );
  }
}
