import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/report_models.dart';
import '../../models/risk_models.dart';

class FollowUpEngine {
  List<FollowUpCheck> build(CrisisCase crisis, RiskAssessment assessment) {
    final checks = <FollowUpCheck>[
      const FollowUpCheck(
        id: 'status_stable',
        prompt: '상태가 더 나빠지지 않았나요?',
        completed: false,
      ),
      const FollowUpCheck(
        id: 'help_connected',
        prompt: '필요한 도움이 연결되었나요?',
        completed: false,
      ),
      const FollowUpCheck(
        id: 'safe_place',
        prompt: '지금 안전한 장소에 있나요?',
        completed: false,
      ),
    ];

    if (assessment.needsOfficialRescue) {
      checks.insert(
        0,
        FollowUpCheck(
          id: 'rescue_status',
          prompt: '공식 구조/전문 도움 요청 상태는 어떻게 되었나요?',
          completed: crisis.rescueRequested,
        ),
      );
    }

    if (crisis.quickSituation == QuickSituation.fireOrSmoke) {
      checks.add(
        const FollowUpCheck(
          id: 'still_evacuated',
          prompt: '대피 상태를 유지하고 있나요? (되돌아가지 않기)',
          completed: false,
        ),
      );
    }

    if (crisis.quickSituation == QuickSituation.mentalCrisis) {
      checks.add(
        const FollowUpCheck(
          id: 'not_alone',
          prompt: '신뢰하는 사람과 함께 있거나 연락이 이어지고 있나요?',
          completed: false,
        ),
      );
    }

    if (crisis.answerOf('no_response_long') == AnswerValue.yes) {
      checks.add(
        const FollowUpCheck(
          id: 'escalation',
          prompt: '무응답이 계속되면 다음 단계로 상향했나요?',
          completed: false,
        ),
      );
    }

    return checks;
  }
}
