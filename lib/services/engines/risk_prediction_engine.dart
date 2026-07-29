import '../../models/enums.dart';
import '../../models/profile_models.dart';

class RiskPredictionEngine {
  List<PredictionResult> predict(SensorSnapshot s) {
    final results = <PredictionResult>[];

    // Elderly inactivity / fall proxy
    if (s.lastMotionMinutesAgo >= 180) {
      results.add(
        PredictionResult(
          levelLabel: '즉시 현장 확인 필요',
          domain: '고령자 무활동·낙상',
          reasons: [
            '마지막 움직임이 ${s.lastMotionMinutesAgo}분 전입니다.',
            '장시간 무활동을 안전으로 보지 않습니다.',
          ],
          recommendedAction: '전화 확인 → 보호자/이웃 확인 → 안전 시 방문 검토',
        ),
      );
    } else if (s.lastMotionMinutesAgo >= 90) {
      results.add(
        PredictionResult(
          levelLabel: '확인 요청',
          domain: '고령자 무활동·낙상',
          reasons: ['평소 대비 움직임이 오래 없습니다.'],
          recommendedAction: '안부 확인 연락을 시도하세요.',
        ),
      );
    } else {
      results.add(
        const PredictionResult(
          levelLabel: '정상',
          domain: '고령자 무활동·낙상',
          reasons: ['최근 움직임이 감지되는 샘플 상태입니다.'],
          recommendedAction: '정기 관찰을 유지하세요.',
        ),
      );
    }

    // Heat
    if (s.temperatureC >= 35) {
      results.add(
        PredictionResult(
          levelLabel: '확인 요청',
          domain: '폭염·한파',
          reasons: ['현재 온도 ${s.temperatureC.toStringAsFixed(1)}°C (샘플)'],
          recommendedAction: '야외·농작업 휴식과 수분·그늘 확보를 확인하세요.',
        ),
      );
    } else if (s.temperatureC <= -5) {
      results.add(
        PredictionResult(
          levelLabel: '확인 요청',
          domain: '폭염·한파',
          reasons: ['한파 가능 온도 ${s.temperatureC.toStringAsFixed(1)}°C'],
          recommendedAction: '난방·체온 유지와 독거가구 안부를 확인하세요.',
        ),
      );
    } else {
      results.add(
        PredictionResult(
          levelLabel: '정상',
          domain: '폭염·한파',
          reasons: ['온도 ${s.temperatureC.toStringAsFixed(1)}°C'],
          recommendedAction: '기상 변화를 계속 관찰하세요.',
        ),
      );
    }

    // Fire / smoke
    if (s.smokeSensor >= 70) {
      results.add(
        const PredictionResult(
          levelLabel: '공식 구조 요청 검토',
          domain: '화재·산불',
          reasons: ['연기 센서 값이 높게 측정되었습니다 (샘플).'],
          recommendedAction: '대피 가능 여부를 확인하고 공식 구조 연결을 검토하세요.',
        ),
      );
    } else if (s.smokeSensor >= 30) {
      results.add(
        const PredictionResult(
          levelLabel: '즉시 현장 확인 필요',
          domain: '화재·산불',
          reasons: ['연기 센서 상승이 감지되었습니다.'],
          recommendedAction: '현장 안전 확인 후 대피 준비를 하세요.',
        ),
      );
    } else {
      results.add(
        const PredictionResult(
          levelLabel: '정상',
          domain: '화재·산불',
          reasons: ['연기 센서가 기준 범위입니다.'],
          recommendedAction: '센서 상태를 주기적으로 점검하세요.',
        ),
      );
    }

    // Gas / confined space
    if (s.gasSensor >= 50) {
      results.add(
        const PredictionResult(
          levelLabel: '즉시 현장 확인 필요',
          domain: '밀폐공간 산소·유해가스',
          reasons: ['가스 센서 값이 높습니다. 임의 진입을 금지합니다.'],
          recommendedAction: '환기·대피 후 공식 전문 확인을 검토하세요.',
        ),
      );
    } else {
      results.add(
        const PredictionResult(
          levelLabel: '관찰 필요',
          domain: '밀폐공간 산소·유해가스',
          reasons: ['가스 값은 낮지만 밀폐공간은 항상 주의가 필요합니다.'],
          recommendedAction: '작업 전 측정 절차를 유지하세요.',
        ),
      );
    }

    // Equipment current anomaly
    final delta = (s.equipmentCurrent - s.usualCurrent).abs();
    if (delta >= s.usualCurrent * 0.4 && s.usualCurrent > 0) {
      results.add(
        PredictionResult(
          levelLabel: '확인 요청',
          domain: '산업설비 과열·이상전류',
          reasons: [
            '현재 전류 ${s.equipmentCurrent}A / 평상시 ${s.usualCurrent}A',
            '편차가 커 이상 가능성이 있습니다.',
          ],
          recommendedAction: '설비 안전정지 검토와 관리자 확인을 진행하세요.',
        ),
      );
    } else {
      results.add(
        PredictionResult(
          levelLabel: '정상',
          domain: '산업설비 과열·이상전류',
          reasons: ['전류 편차가 작습니다.'],
          recommendedAction: '감시 유지',
        ),
      );
    }

    if (s.workerInHazardZone) {
      results.add(
        const PredictionResult(
          levelLabel: '즉시 현장 확인 필요',
          domain: '작업자 위험구역 진입',
          reasons: ['작업자가 위험구역에 있는 샘플 상태입니다.'],
          recommendedAction: '즉시 확인·이탈 안내와 설비 안전정지 검토',
        ),
      );
    }

    if (s.riverLevelDeltaCm >= 50) {
      results.add(
        PredictionResult(
          levelLabel: '확인 요청',
          domain: '침수·하천 수위',
          reasons: ['하천 수위가 ${s.riverLevelDeltaCm}cm 상승(샘플)했습니다.'],
          recommendedAction: '저지대·농경지 접근을 제한하세요.',
        ),
      );
    }

    if (s.locationStationaryMinutes >= 240) {
      results.add(
        PredictionResult(
          levelLabel: '확인 요청',
          domain: '조난·장시간 위치 정지',
          reasons: ['위치가 ${s.locationStationaryMinutes}분간 정지(샘플)입니다.'],
          recommendedAction: '연락 확인 후 필요 시 구조 연결을 검토하세요.',
        ),
      );
    }

    return results;
  }

  RiskLevel mapLabelToRisk(String label) {
    switch (label) {
      case '공식 구조 요청 검토':
        return RiskLevel.critical;
      case '즉시 현장 확인 필요':
        return RiskLevel.high;
      case '확인 요청':
        return RiskLevel.moderate;
      case '관찰 필요':
        return RiskLevel.moderate;
      case '정상':
        return RiskLevel.low;
      default:
        return RiskLevel.unknown;
    }
  }
}
