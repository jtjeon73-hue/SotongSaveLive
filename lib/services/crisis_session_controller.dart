import 'package:flutter/foundation.dart';

import '../../models/crisis_case.dart';
import '../../models/enums.dart';
import '../../models/profile_models.dart';
import '../../models/question_models.dart';
import '../../models/report_models.dart';
import 'engines/life_safety_orchestrator.dart';
import 'storage/local_app_storage.dart';

class CrisisSessionController extends ChangeNotifier {
  CrisisSessionController({
    LifeSafetyOrchestrator? orchestrator,
    AppStorage? storage,
  }) : _orchestrator = orchestrator ?? LifeSafetyOrchestrator(),
       _storage = storage ?? LocalAppStorage();

  final LifeSafetyOrchestrator _orchestrator;
  final AppStorage _storage;

  CrisisCase? crisis;
  SafetyProfile profile = SafetyProfile();
  List<FamilyMemberCard> family = [];
  PreventionPlan? lastPrevention;
  bool storing = false;
  bool sampleMode = true;

  LifeSafetyOrchestrator get orchestrator => _orchestrator;

  Future<void> init() async {
    crisis = await _storage.loadCrisis();
    profile = await _storage.loadProfile() ?? SafetyProfile();
    family = await _storage.loadFamily();
    notifyListeners();
  }

  Future<void> _persist() async {
    storing = true;
    notifyListeners();
    if (crisis != null) {
      await _storage.saveCrisis(crisis!);
    }
    storing = false;
    notifyListeners();
  }

  Future<void> startAssessment({
    required String freeText,
    QuickSituation? situation,
    SubjectType subjectType = SubjectType.self,
    AloneStatus aloneStatus = AloneStatus.unknown,
    String locationText = '',
    bool isWitnessMode = false,
  }) async {
    crisis = _orchestrator.createCase(
      freeText: freeText,
      quickSituation: situation,
      subjectType: subjectType,
      aloneStatus: aloneStatus,
      locationText: locationText,
      isWitnessMode: isWitnessMode,
    );
    lastPrevention = null;
    await _persist();
  }

  SafetyQuestion? get nextQuestion =>
      crisis == null ? null : _orchestrator.nextQuestion(crisis!);

  Future<void> answerCurrent(QuestionOption option) async {
    final q = nextQuestion;
    if (crisis == null || q == null) return;
    crisis = _orchestrator.answer(crisis!, q, option);
    await _persist();
  }

  Future<void> reviseAnswer(String questionId, QuestionOption option) async {
    if (crisis == null) return;
    crisis = _orchestrator.updateAnswer(crisis!, questionId, option);
    await _persist();
  }

  Future<void> markAction(String id, ActionStatus status) async {
    if (crisis == null) return;
    crisis = _orchestrator.markAction(crisis!, id, status);
    await _persist();
  }

  Future<void> setFlags({bool? rescue, bool? guardian}) async {
    if (crisis == null) return;
    crisis = _orchestrator.setFlags(
      crisis!,
      rescueRequested: rescue,
      guardianContacted: guardian,
    );
    await _persist();
  }

  Future<PreventionPlan> closeIncident() async {
    if (crisis == null) {
      return const PreventionPlan(
        summary: '종료할 사건이 없습니다.',
        whatWentWell: [],
        unknownGaps: [],
        equipmentToPrepare: [],
        shareWithFamily: [],
        facilityImprovements: [],
        followUpChecks: [],
      );
    }
    final plan = _orchestrator.closeCase(crisis!);
    crisis = crisis!.copy()..isClosed = true;
    lastPrevention = plan;
    await _persist();
    return plan;
  }

  Future<void> saveProfile(SafetyProfile p) async {
    profile = p..updatedAt = DateTime.now();
    await _storage.saveProfile(profile);
    notifyListeners();
  }

  Future<void> saveFamily(List<FamilyMemberCard> members) async {
    family = members;
    await _storage.saveFamily(family);
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _storage.clearAllUserData();
    crisis = null;
    profile = SafetyProfile();
    family = [];
    lastPrevention = null;
    notifyListeners();
  }
}
