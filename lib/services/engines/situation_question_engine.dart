import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/question_models.dart';

class SituationQuestionEngine {
  static const yesNoUnknown = [
    QuestionOption(id: 'yes', label: '예', value: AnswerValue.yes),
    QuestionOption(id: 'no', label: '아니오', value: AnswerValue.no),
    QuestionOption(
      id: 'unknown',
      label: '확인할 수 없음',
      value: AnswerValue.unknown,
    ),
  ];

  SafetyQuestion? nextQuestion(CrisisCase crisis) {
    final pending =
        _questionsFor(crisis).where((q) => !crisis.hasAnswer(q.id)).toList()
          ..sort((a, b) => b.priority.compareTo(a.priority));
    if (pending.isEmpty) return null;
    return pending.first;
  }

  List<SafetyQuestion> allQuestions(CrisisCase crisis) => _questionsFor(crisis);

  List<SafetyQuestion> _questionsFor(CrisisCase crisis) {
    final s = crisis.quickSituation;
    final questions = <SafetyQuestion>[];

    if (crisis.isWitnessMode) {
      questions.addAll([
        const SafetyQuestion(
          id: 'scene_safe',
          prompt: '지금 현장은 목격자인 당신에게도 안전한가요?',
          helpText: '위험이 있으면 먼저 안전한 위치로 이동하세요.',
          options: yesNoUnknown,
          priority: 100,
        ),
        const SafetyQuestion(
          id: 'consciousness',
          prompt: '환자(또는 상대)가 말에 반응하나요?',
          options: yesNoUnknown,
          priority: 95,
        ),
        const SafetyQuestion(
          id: 'breathing',
          prompt: '숨은 쉬고 있는 것으로 보이나요?',
          options: yesNoUnknown,
          priority: 94,
        ),
        const SafetyQuestion(
          id: 'bleeding',
          prompt: '눈에 띄는 심한 출혈이 있나요?',
          options: yesNoUnknown,
          priority: 90,
        ),
        const SafetyQuestion(
          id: 'movement',
          prompt: '스스로 움직이거나 자세를 바꾸나요?',
          options: yesNoUnknown,
          priority: 80,
        ),
      ]);
    }

    switch (s) {
      case QuickSituation.personCollapsed:
        questions.addAll([
          const SafetyQuestion(
            id: 'elderly',
            prompt: '당사자가 고령자인가요?',
            options: yesNoUnknown,
            priority: 88,
          ),
          const SafetyQuestion(
            id: 'heat',
            prompt: '폭염·고온 환경인가요?',
            options: yesNoUnknown,
            priority: 87,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '의식이 있거나 말에 반응하나요?',
            options: yesNoUnknown,
            priority: 96,
          ),
          const SafetyQuestion(
            id: 'breathing',
            prompt: '숨은 쉬고 있나요?',
            options: yesNoUnknown,
            priority: 95,
          ),
          const SafetyQuestion(
            id: 'onset_time',
            prompt: '쓰러진 시각을 대략 알 수 있나요?',
            options: yesNoUnknown,
            priority: 70,
          ),
          const SafetyQuestion(
            id: 'speech_odd',
            prompt: '말이 어눌하거나 한쪽이 이상해 보이나요?',
            options: yesNoUnknown,
            priority: 85,
          ),
          const SafetyQuestion(
            id: 'pesticide',
            prompt: '농약·화학물질 노출 가능성이 있나요?',
            options: yesNoUnknown,
            priority: 75,
          ),
        ]);
      case QuickSituation.trafficOrMachineAccident:
        questions.addAll([
          const SafetyQuestion(
            id: 'scene_safe',
            prompt: '현장과 기계가 추가 작동할 위험이 있나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'machine_running',
            prompt: '전원·에너지원을 안전하게 차단할 수 있나요?',
            options: yesNoUnknown,
            priority: 98,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '의식이 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'breathing',
            prompt: '호흡이 있나요?',
            options: yesNoUnknown,
            priority: 89,
          ),
          const SafetyQuestion(
            id: 'bleeding',
            prompt: '심한 출혈이 있나요?',
            options: yesNoUnknown,
            priority: 88,
          ),
        ]);
      case QuickSituation.fireOrSmoke:
        questions.addAll([
          const SafetyQuestion(
            id: 'fire_nearby',
            prompt: '불·연기가 지금 가까이 있나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'evac_possible',
            prompt: '안전한 방향으로 대피할 수 있나요?',
            options: yesNoUnknown,
            priority: 95,
          ),
          const SafetyQuestion(
            id: 'mobility_limit_person',
            prompt: '이동이 어려운 사람이 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'vehicle_available',
            prompt: '차량을 안전하게 이용할 수 있나요?',
            options: yesNoUnknown,
            priority: 70,
          ),
          const SafetyQuestion(
            id: 'smoke_inhalation',
            prompt: '연기 흡입이 걱정되나요?',
            options: yesNoUnknown,
            priority: 80,
          ),
        ]);
      case QuickSituation.mentalCrisis:
        questions.addAll([
          const SafetyQuestion(
            id: 'immediate_danger',
            prompt: '지금 당장 자신을 해칠 위험이 있나요?',
            helpText: '판단하거나 훈계하지 않습니다. 안전하게 함께 확인합니다.',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'alone_now',
            prompt: '지금 혼자 계신가요?',
            options: yesNoUnknown,
            priority: 95,
          ),
          const SafetyQuestion(
            id: 'safe_distance',
            prompt: '위험한 물건·장소에서 거리를 둘 수 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'trusted_person',
            prompt: '신뢰하는 사람과 함께 있을 수 있나요?',
            options: yesNoUnknown,
            priority: 85,
          ),
        ]);
      case QuickSituation.livingCollapse:
        questions.addAll([
          const SafetyQuestion(
            id: 'safe_tonight',
            prompt: '오늘 밤 안전하게 있을 장소가 있나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'food_meds',
            prompt: '오늘·내일 필요한 음식·약은 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'heat_cold',
            prompt: '난방·냉방·기본 체온 유지는 가능한가요?',
            options: yesNoUnknown,
            priority: 85,
          ),
          const SafetyQuestion(
            id: 'care_support',
            prompt: '돌봄이 필요한 가족·본인이 있나요?',
            options: yesNoUnknown,
            priority: 80,
          ),
          const SafetyQuestion(
            id: 'life_threat_now',
            prompt: '지금 당장 생명에 위협이 되는 증상이 있나요?',
            options: yesNoUnknown,
            priority: 98,
          ),
        ]);
      case QuickSituation.chemicalExposure:
        questions.addAll([
          const SafetyQuestion(
            id: 'scene_safe',
            prompt: '노출 현장에서 안전하게 나올 수 있나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'breathing',
            prompt: '숨쉬기가 어렵나요?',
            options: yesNoUnknown,
            priority: 95,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '의식이 또렷한가요?',
            options: yesNoUnknown,
            priority: 90,
          ),
        ]);
      case QuickSituation.breathingDifficulty:
        questions.addAll([
          const SafetyQuestion(
            id: 'breathing',
            prompt: '지금 숨을 제대로 쉴 수 있나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '의식이 또렷한가요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'alone_now',
            prompt: '혼자 계신가요?',
            options: yesNoUnknown,
            priority: 80,
          ),
        ]);
      case QuickSituation.heavyBleeding:
        questions.addAll([
          const SafetyQuestion(
            id: 'bleeding',
            prompt: '피가 멈추지 않고 계속 나오나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '의식이 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
        ]);
      case QuickSituation.drowningOrIsolation:
        questions.addAll([
          const SafetyQuestion(
            id: 'scene_safe',
            prompt: '구조자가 들어가도 안전한가요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'breathing',
            prompt: '호흡이 확인되나요?',
            options: yesNoUnknown,
            priority: 95,
          ),
        ]);
      case QuickSituation.threatOrViolence:
        questions.addAll([
          const SafetyQuestion(
            id: 'scene_safe',
            prompt: '지금 안전한 곳으로 이동할 수 있나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'immediate_danger',
            prompt: '지금 당장 위험이 계속되고 있나요?',
            options: yesNoUnknown,
            priority: 98,
          ),
        ]);
      case QuickSituation.suddenBehaviorChange:
        questions.addAll([
          const SafetyQuestion(
            id: 'speech_odd',
            prompt: '말이나 행동이 평소와 갑자기 다른가요?',
            options: yesNoUnknown,
            priority: 95,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '의식은 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'onset_time',
            prompt: '시작된 시각을 알 수 있나요?',
            options: yesNoUnknown,
            priority: 70,
          ),
        ]);
      case QuickSituation.unknown:
      case null:
        questions.addAll([
          const SafetyQuestion(
            id: 'life_threat_now',
            prompt: '지금 당장 생명에 위협이 된다고 느끼시나요?',
            options: yesNoUnknown,
            priority: 100,
          ),
          const SafetyQuestion(
            id: 'consciousness',
            prompt: '본인 또는 상대의 의식은 있나요?',
            options: yesNoUnknown,
            priority: 90,
          ),
          const SafetyQuestion(
            id: 'breathing',
            prompt: '호흡은 괜찮은가요?',
            options: yesNoUnknown,
            priority: 89,
          ),
          const SafetyQuestion(
            id: 'no_response_long',
            prompt: '오랫동안 응답이 없는 상황인가요?',
            options: yesNoUnknown,
            priority: 80,
          ),
        ]);
    }

    // Deduplicate by id keeping highest priority.
    final map = <String, SafetyQuestion>{};
    for (final q in questions) {
      final existing = map[q.id];
      if (existing == null || q.priority > existing.priority) {
        map[q.id] = q;
      }
    }
    return map.values.toList();
  }
}
