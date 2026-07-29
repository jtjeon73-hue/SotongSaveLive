import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/report_models.dart';
import '../../models/risk_models.dart';

class SafetyReportGenerator {
  SituationReport generate(CrisisCase crisis, RiskAssessment assessment) {
    final fields = <String, String>{
      '사람': crisis.subjectType == SubjectType.self ? '본인' : '다른 사람',
      '혼자 여부': switch (crisis.aloneStatus) {
        AloneStatus.alone => '혼자 있음',
        AloneStatus.withOthers => '다른 사람과 함께',
        AloneStatus.unknown => '확인 불가',
      },
      '빠른 상황': crisis.quickSituation?.labelKo ?? '미선택',
      '위치': crisis.locationText.isEmpty ? '미입력' : crisis.locationText,
      '위험도': assessment.level.labelKo,
      '우선 위험': assessment.primaryRisk,
      '구조 요청': crisis.rescueRequested ? '요청함/요청 중' : '아직 아님',
      '보호자 연락': crisis.guardianContacted ? '연락함' : '아직 아님',
      '발생 시각': (crisis.startedAt ?? crisis.createdAt).toIso8601String(),
    };

    String ans(String id, String label) {
      final v = crisis.answerOf(id);
      if (v == null) return '';
      final text = switch (v) {
        AnswerValue.yes => '예',
        AnswerValue.no => '아니오',
        AnswerValue.unknown => '확인 불가',
        AnswerValue.notApplicable => '해당 없음',
      };
      fields[label] = text;
      return '$label: $text';
    }

    final detailLines = <String>[
      ans('consciousness', '의식'),
      ans('breathing', '호흡'),
      ans('bleeding', '출혈'),
      ans('speech_odd', '말·행동 이상'),
      ans('pesticide', '농약·화학 노출'),
      ans('machine_running', '전원 차단 가능'),
      ans('fire_nearby', '불·연기 근접'),
      ans('immediate_danger', '즉각 위험'),
      ans('safe_tonight', '오늘 밤 안전 장소'),
    ].where((e) => e.isNotEmpty);

    final free = crisis.freeText.trim().isEmpty
        ? '자유 서술 없음'
        : crisis.freeText.trim();

    final rescueSummary = [
      '긴급 상황 요약 (구조 전달용)',
      '위험도: ${assessment.level.labelKo} / 우선위험: ${assessment.primaryRisk}',
      '상황: ${crisis.quickSituation?.labelKo ?? '미상'}',
      '위치: ${fields['위치']}',
      '사람: ${fields['사람']} / ${fields['혼자 여부']}',
      ...detailLines,
      '현재 수행: ${crisis.actionSteps.where((s) => s.status.name == 'completed').map((s) => s.title).join(', ').ifEmpty('정리 중')}',
      '자유 설명: $free',
      '주의: 확인되지 않은 전화번호·기관명을 포함하지 않았습니다.',
    ].join('\n');

    final guardianSummary = [
      '보호자용 요약',
      '${assessment.level.labelKo} 위험으로 판단되어 확인이 필요합니다.',
      '상황: ${crisis.quickSituation?.labelKo ?? '미상'}',
      '위치: ${fields['위치']}',
      '지금 필요한 도움: ${assessment.needsOfficialRescue ? '공식 구조/전문 도움 연결 검토' : '상태 지속 관찰과 연락'}',
      'AI는 의료진·구조기관을 대신하지 않습니다.',
    ].join('\n');

    final fullText = [
      'SotongSaveLive 상황보고서',
      '제목: ${assessment.primaryRisk}',
      ...fields.entries.map((e) => '${e.key}: ${e.value}'),
      '자유 설명: $free',
      '적용 규칙: ${assessment.appliedRules.join(', ')}',
      assessment.summary,
    ].join('\n');

    return SituationReport(
      headline: assessment.primaryRisk,
      fullText: fullText,
      guardianSummary: guardianSummary,
      rescueSummary: rescueSummary,
      fields: fields,
      includesPersonalInfo: crisis.locationText.isNotEmpty,
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
