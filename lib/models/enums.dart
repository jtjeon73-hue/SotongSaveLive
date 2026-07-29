enum RiskLevel {
  unknown,
  low,
  moderate,
  high,
  critical;

  String get labelKo {
    switch (this) {
      case RiskLevel.unknown:
        return '정보 부족';
      case RiskLevel.low:
        return '낮음';
      case RiskLevel.moderate:
        return '주의';
      case RiskLevel.high:
        return '높음';
      case RiskLevel.critical:
        return '긴급';
    }
  }

  int get rank {
    switch (this) {
      case RiskLevel.unknown:
        return 2;
      case RiskLevel.low:
        return 1;
      case RiskLevel.moderate:
        return 3;
      case RiskLevel.high:
        return 4;
      case RiskLevel.critical:
        return 5;
    }
  }

  static RiskLevel maxOf(Iterable<RiskLevel> levels) {
    var result = RiskLevel.low;
    for (final level in levels) {
      if (level.rank > result.rank) {
        result = level;
      }
    }
    return result;
  }
}

enum QuickSituation {
  personCollapsed,
  breathingDifficulty,
  heavyBleeding,
  suddenBehaviorChange,
  chemicalExposure,
  fireOrSmoke,
  trafficOrMachineAccident,
  drowningOrIsolation,
  threatOrViolence,
  mentalCrisis,
  livingCollapse,
  unknown;

  String get labelKo {
    switch (this) {
      case QuickSituation.personCollapsed:
        return '사람이 쓰러졌어요';
      case QuickSituation.breathingDifficulty:
        return '숨쉬기 힘들어해요';
      case QuickSituation.heavyBleeding:
        return '피가 많이 나요';
      case QuickSituation.suddenBehaviorChange:
        return '말이나 행동이 갑자기 이상해요';
      case QuickSituation.chemicalExposure:
        return '농약·약물·가스에 노출됐어요';
      case QuickSituation.fireOrSmoke:
        return '불·연기·산불이 발생했어요';
      case QuickSituation.trafficOrMachineAccident:
        return '교통·농기계·산업사고가 났어요';
      case QuickSituation.drowningOrIsolation:
        return '물에 빠졌거나 고립됐어요';
      case QuickSituation.threatOrViolence:
        return '누군가가 위협하고 있어요';
      case QuickSituation.mentalCrisis:
        return '마음이 무너지고 삶을 포기하고 싶어요';
      case QuickSituation.livingCollapse:
        return '먹을 곳·잘 곳·약을 구하기 어려워요';
      case QuickSituation.unknown:
        return '어떤 상황인지 모르겠어요';
    }
  }
}

enum SubjectType { self, other }

enum AloneStatus { alone, withOthers, unknown }

enum AnswerValue { yes, no, unknown, notApplicable }

enum ActionStatus { pending, completed, unable, changed }
