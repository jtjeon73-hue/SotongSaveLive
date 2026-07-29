import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/risk_models.dart';

class RiskAssessmentEngine {
  RiskAssessment assess(CrisisCase crisis) {
    final factors = <RiskFactor>[];
    final rules = <String>[];

    void add(
      String id,
      String label,
      RiskLevel level,
      String reason, {
      bool lifeThreat = false,
    }) {
      factors.add(
        RiskFactor(
          id: id,
          label: label,
          level: level,
          reason: reason,
          isLifeThreatSignal: lifeThreat,
        ),
      );
    }

    final situation = crisis.quickSituation;
    final text = crisis.freeText.toLowerCase();

    if (situation == QuickSituation.personCollapsed ||
        text.contains('쓰러') ||
        text.contains('의식')) {
      add(
        'collapse',
        '갑작스러운 쓰러짐/의식 관련 신호',
        RiskLevel.high,
        '쓰러짐은 생명위험 가능성이 있어 보수적으로 상향합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_COLLAPSE_HIGH');
    }

    if (situation == QuickSituation.breathingDifficulty ||
        crisis.answerOf('breathing') == AnswerValue.no ||
        text.contains('숨') ||
        text.contains('호흡')) {
      add(
        'breathing',
        '호흡 곤란 또는 호흡 확인 필요',
        RiskLevel.critical,
        '호흡 이상은 즉시 공식 구조 연결을 우선합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_BREATHING_CRITICAL');
    }

    if (situation == QuickSituation.heavyBleeding ||
        crisis.answerOf('bleeding') == AnswerValue.yes ||
        text.contains('피') ||
        text.contains('출혈')) {
      add(
        'bleeding',
        '심한 출혈 가능성',
        RiskLevel.critical,
        '대량 출혈 신호는 생명위험으로 취급합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_BLEEDING_CRITICAL');
    }

    if (situation == QuickSituation.suddenBehaviorChange ||
        crisis.answerOf('speech_odd') == AnswerValue.yes ||
        text.contains('말') && text.contains('이상')) {
      add(
        'neuro',
        '갑작스러운 말·행동 변화',
        RiskLevel.high,
        '신경계 응급 가능성을 배제하지 않고 추가 확인이 필요합니다. 진단명은 확정하지 않습니다.',
        lifeThreat: true,
      );
      rules.add('RULE_SUDDEN_NEURO_HIGH');
    }

    if (situation == QuickSituation.chemicalExposure ||
        crisis.answerOf('pesticide') == AnswerValue.yes ||
        text.contains('농약') ||
        text.contains('가스') ||
        text.contains('약물')) {
      add(
        'chemical',
        '농약·약물·가스 노출 가능성',
        RiskLevel.high,
        '노출 경로와 현장 안전을 우선 확인하고 임의 해독·약물 투여를 금지합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_CHEMICAL_HIGH');
    }

    if (situation == QuickSituation.fireOrSmoke ||
        crisis.answerOf('fire_nearby') == AnswerValue.yes ||
        text.contains('불') ||
        text.contains('연기') ||
        text.contains('산불')) {
      add(
        'fire',
        '화재·연기·산불',
        RiskLevel.critical,
        '대피와 현장 안전이 최우선입니다. 되돌아가면 안 되는 상황을 강조합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_FIRE_CRITICAL');
    }

    if (situation == QuickSituation.trafficOrMachineAccident ||
        crisis.answerOf('machine_running') == AnswerValue.yes ||
        text.contains('농기계') ||
        text.contains('끼임') ||
        text.contains('산업')) {
      add(
        'machine',
        '교통·농기계·산업사고',
        RiskLevel.critical,
        '기계 추가 작동과 목격자 2차 사고를 최우선 위험으로 봅니다.',
        lifeThreat: true,
      );
      rules.add('RULE_MACHINE_CRITICAL');
    }

    if (situation == QuickSituation.drowningOrIsolation ||
        text.contains('물에') ||
        text.contains('고립')) {
      add(
        'isolation',
        '익수·고립',
        RiskLevel.critical,
        '구조자 안전과 공식 구조 요청을 우선합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_ISOLATION_CRITICAL');
    }

    if (situation == QuickSituation.threatOrViolence ||
        text.contains('위협') ||
        text.contains('폭력')) {
      add(
        'violence',
        '위협·폭력',
        RiskLevel.critical,
        '현장 이탈과 안전 확보가 우선이며, 확인되지 않은 전화번호를 생성하지 않습니다.',
        lifeThreat: true,
      );
      rules.add('RULE_VIOLENCE_CRITICAL');
    }

    if (situation == QuickSituation.mentalCrisis ||
        text.contains('포기') ||
        text.contains('죽고') ||
        text.contains('자살')) {
      add(
        'mental',
        '정신적 위기',
        RiskLevel.high,
        '비난·훈계·진단 없이 즉각 위험과 동행 가능성을 확인합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_MENTAL_HIGH');
    }

    if (situation == QuickSituation.livingCollapse ||
        text.contains('잘 곳') ||
        text.contains('먹을') ||
        text.contains('약')) {
      add(
        'living',
        '생활 붕괴',
        RiskLevel.moderate,
        '즉시 생명위험과 생활지원 문제를 구분하고, 존재하지 않는 제도를 만들지 않습니다.',
      );
      rules.add('RULE_LIVING_MODERATE');
    }

    if (crisis.answerOf('heat') == AnswerValue.yes || text.contains('폭염')) {
      add(
        'heat',
        '폭염 환경',
        RiskLevel.high,
        '고령자+쓰러짐+폭염 조합은 위험도를 상향합니다.',
        lifeThreat: true,
      );
      rules.add('RULE_HEAT_ELDERLY');
    }

    if (crisis.answerOf('elderly') == AnswerValue.yes || text.contains('고령')) {
      add(
        'elderly',
        '고령자 관련 상황',
        RiskLevel.moderate,
        '고령자는 같은 신호라도 보수적으로 평가합니다.',
      );
      rules.add('RULE_ELDERLY');
    }

    if (crisis.answerOf('consciousness') == AnswerValue.no) {
      add(
        'unconscious',
        '의식 없음 또는 반응 없음',
        RiskLevel.critical,
        '의식 없음은 즉시 공식 구조 요청 대상입니다.',
        lifeThreat: true,
      );
      rules.add('RULE_UNCONSCIOUS');
    }

    if (crisis.answerOf('no_response_long') == AnswerValue.yes) {
      add(
        'no_response',
        '장시간 무응답',
        RiskLevel.high,
        '평소 패턴과 비교해 단계적으로 상향합니다. 무응답을 안전으로 보지 않습니다.',
        lifeThreat: true,
      );
      rules.add('RULE_NO_RESPONSE');
    }

    // Unknown answers must NEVER be treated as safe.
    for (final entry in crisis.answers.entries) {
      if (entry.value.value == AnswerValue.unknown) {
        add(
          'unknown_${entry.key}',
          '확인 불가: ${entry.key}',
          RiskLevel.moderate,
          '확인 불가는 안전으로 처리하지 않고 관찰·확인 필요로 유지합니다.',
        );
        rules.add('RULE_UNKNOWN_NOT_SAFE_${entry.key}');
      }
    }

    if (crisis.aloneStatus == AloneStatus.alone) {
      add(
        'alone',
        '혼자 있는 상태',
        RiskLevel.moderate,
        '혼자 있을 때는 도움 요청 경로를 더 빠르게 준비합니다.',
      );
      rules.add('RULE_ALONE');
    }

    if (factors.isEmpty) {
      add(
        'insufficient',
        '정보 부족',
        RiskLevel.unknown,
        '충분한 정보가 없어 위험도를 낮게 단정하지 않습니다.',
      );
      rules.add('RULE_INSUFFICIENT_INFO');
    }

    final level = RiskLevel.maxOf(factors.map((f) => f.level));
    final hasLifeThreat = factors.any((f) => f.isLifeThreatSignal);
    final needsRescue =
        hasLifeThreat || level == RiskLevel.critical || level == RiskLevel.high;

    factors.sort((a, b) => b.level.rank.compareTo(a.level.rank));
    final primary = factors.first.label;

    return RiskAssessment(
      level: level,
      primaryRisk: primary,
      factors: factors,
      appliedRules: rules.toSet().toList(),
      needsOfficialRescue: needsRescue,
      summary: needsRescue
          ? '공식 구조기관·전문인력 연결을 우선 검토하세요. AI는 의사·구조대를 대신하지 않습니다.'
          : '추가 확인이 필요합니다. 상태가 나빠지면 즉시 공식 도움을 요청하세요.',
    );
  }
}
