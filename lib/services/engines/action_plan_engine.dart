import '../../models/action_models.dart';
import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/risk_models.dart';

class ActionPlanEngine {
  ({List<ActionStep> steps, List<ProhibitedAction> prohibited}) build(
    CrisisCase crisis,
    RiskAssessment assessment,
  ) {
    final steps = <ActionStep>[];
    final prohibited = <ProhibitedAction>[];
    final s = crisis.quickSituation;

    if (assessment.needsOfficialRescue) {
      steps.add(
        const ActionStep(
          id: 'call_official_help',
          title: '공식 구조·전문 도움 요청',
          instruction:
              '가능한 즉시 공식 긴급구조 또는 주변 신뢰할 수 있는 사람에게 도움을 요청하세요. AI는 구조대를 대신하지 않습니다.',
          priority: 100,
          isImmediate: true,
        ),
      );
    }

    switch (s) {
      case QuickSituation.personCollapsed:
        steps.addAll([
          const ActionStep(
            id: 'check_abc',
            title: '의식·호흡 확인',
            instruction: '말을 걸고 반응과 호흡을 확인하세요. 확인 불가면 안전하게 가정하지 마세요.',
            priority: 95,
            isImmediate: true,
          ),
          const ActionStep(
            id: 'cool_safe_place',
            title: '시원하고 안전한 장소 확보',
            instruction: '폭염이라면 그늘·실내로 옮길 수 있는지 먼저 현장 안전을 확인하세요.',
            priority: 85,
          ),
        ]);
        prohibited.add(
          const ProhibitedAction(
            id: 'no_force_drink',
            label: '음식·음료를 억지로 주지 않기',
            reason: '의식이 불명확할 때 임의로 먹이거나 마시게 하면 위험할 수 있습니다.',
          ),
        );
        prohibited.add(
          const ProhibitedAction(
            id: 'no_diagnosis',
            label: '질환명을 단정하지 않기',
            reason: 'AI와 목격자는 진단을 내리지 않습니다.',
          ),
        );
      case QuickSituation.trafficOrMachineAccident:
        steps.addAll([
          const ActionStep(
            id: 'secure_scene',
            title: '현장·기계 추가 위험 차단',
            instruction: '가능하면 전원·에너지원을 안전하게 차단하세요. 무리한 구조는 하지 마세요.',
            priority: 99,
            isImmediate: true,
          ),
          const ActionStep(
            id: 'witness_safety',
            title: '목격자 안전 확보',
            instruction: '구조하려는 사람이 끼임·전복·감전 위험에 들어가지 않게 하세요.',
            priority: 97,
            isImmediate: true,
          ),
          const ActionStep(
            id: 'check_vitals',
            title: '의식·호흡·출혈 확인',
            instruction: '확인한 내용을 구조 요청 시 전달할 수 있게 짧게 정리하세요.',
            priority: 90,
          ),
        ]);
        prohibited.add(
          const ProhibitedAction(
            id: 'no_force_pull',
            label: '끼인 사람을 무리하게 빼지 않기',
            reason: '추가 손상과 구조자 부상을 막을 수 있습니다.',
          ),
        );
      case QuickSituation.fireOrSmoke:
        steps.addAll([
          const ActionStep(
            id: 'evacuate',
            title: '안전한 방향으로 대피',
            instruction: '바람·연기 방향을 피하고, 이동이 어려운 사람과 함께 대피 계획을 세우세요.',
            priority: 100,
            isImmediate: true,
          ),
          const ActionStep(
            id: 'no_return_check',
            title: '대피 상태 유지',
            instruction: '물건 때문에 되돌아가지 마세요. 대피 후 상태를 계속 확인하세요.',
            priority: 90,
          ),
        ]);
        prohibited.add(
          const ProhibitedAction(
            id: 'no_reenter',
            label: '불·연기 속으로 되돌아가지 않기',
            reason: '연기 흡입과 고립 위험이 급격히 커집니다.',
          ),
        );
      case QuickSituation.mentalCrisis:
        steps.addAll([
          const ActionStep(
            id: 'stay_with',
            title: '혼자가 되지 않도록 하기',
            instruction: '가능하면 신뢰하는 사람과 함께 계세요. 비난하거나 훈계하지 말고 곁을 지켜 주세요.',
            priority: 100,
            isImmediate: true,
          ),
          const ActionStep(
            id: 'distance_from_harm',
            title: '위험한 물건·장소와 거리 두기',
            instruction: '안전한 공간으로 옮길 수 있으면 그렇게 하세요.',
            priority: 95,
          ),
          const ActionStep(
            id: 'official_mental_help',
            title: '공식 전문 도움 연결 준비',
            instruction: '검증된 공식 출처의 연락처만 사용하세요. 이 앱은 전화번호를 임의로 만들지 않습니다.',
            priority: 90,
          ),
        ]);
        prohibited.add(
          const ProhibitedAction(
            id: 'no_blame',
            label: '비난·단정·진단 표현 금지',
            reason: '정신적 위기에서 훈계나 확정 진단 표현은 위험을 키울 수 있습니다.',
          ),
        );
      case QuickSituation.livingCollapse:
        steps.addAll([
          const ActionStep(
            id: 'tonight_shelter',
            title: '오늘 밤 안전 장소 확인',
            instruction: '즉시 생명위험과 생활지원을 구분하세요. 없는 지원제도를 만들어내지 마세요.',
            priority: 95,
            isImmediate: true,
          ),
          const ActionStep(
            id: 'priority_needs',
            title: '음식·약·난방·돌봄 우선순위 정리',
            instruction: '필요한 지원 분야를 적어 공식 복지·의료·지역지원 연결 준비목록을 만드세요.',
            priority: 85,
          ),
        ]);
      case QuickSituation.chemicalExposure:
        steps.add(
          const ActionStep(
            id: 'leave_exposure',
            title: '노출 현장에서 안전 이동',
            instruction: '가능하면 환기가 되는 안전한 곳으로 이동하고 공식 도움을 요청하세요.',
            priority: 98,
            isImmediate: true,
          ),
        );
        prohibited.add(
          const ProhibitedAction(
            id: 'no_self_med',
            label: '임의 해독제·약물·용량 지시 금지',
            reason: '검증되지 않은 치료 지시는 제공하지 않습니다.',
          ),
        );
      case QuickSituation.breathingDifficulty:
      case QuickSituation.heavyBleeding:
      case QuickSituation.drowningOrIsolation:
      case QuickSituation.threatOrViolence:
      case QuickSituation.suddenBehaviorChange:
      case QuickSituation.unknown:
      case null:
        steps.add(
          const ActionStep(
            id: 'observe_and_report',
            title: '상태 관찰과 전달문 준비',
            instruction: '확인된 사실만 짧게 정리하고, 악화되면 즉시 공식 도움을 요청하세요.',
            priority: 80,
          ),
        );
    }

    if (crisis.answerOf('no_response_long') == AnswerValue.yes) {
      steps.addAll([
        const ActionStep(
          id: 'call_check',
          title: '전화로 안부 확인',
          instruction: '평소 생활 패턴과 마지막 활동을 비교하며 확인하세요.',
          priority: 92,
          isImmediate: true,
        ),
        const ActionStep(
          id: 'neighbor_guardian',
          title: '이웃·보호자 확인',
          instruction: '응답이 없으면 다음 단계로 상향하세요. 무응답을 안전으로 보지 마세요.',
          priority: 88,
        ),
        const ActionStep(
          id: 'visit_if_safe',
          title: '현장 방문 가능 여부 확인',
          instruction: '방문이 가능하고 안전할 때만 확인하세요. 위험징후가 있으면 공식 도움을 요청하세요.',
          priority: 84,
        ),
      ]);
    }

    if (crisis.aloneStatus == AloneStatus.alone) {
      steps.add(
        const ActionStep(
          id: 'notify_someone',
          title: '지금 연락 가능한 사람에게 알리기',
          instruction: '혼자 있다면 위치와 상황을 짧게 전달하세요.',
          priority: 86,
        ),
      );
    }

    steps.sort((a, b) => b.priority.compareTo(a.priority));
    return (steps: steps, prohibited: prohibited);
  }
}
