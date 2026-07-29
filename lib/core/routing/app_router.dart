import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/ai_lab/ai_lab_page.dart';
import '../../features/crisis_assessment/crisis_assessment_page.dart';
import '../../features/family_safety/family_safety_page.dart';
import '../../features/home/home_page.dart';
import '../../features/incident_follow_up/incident_follow_up_page.dart';
import '../../features/industrial_safety/industrial_safety_page.dart';
import '../../features/rescue_command/rescue_command_page.dart';
import '../../features/risk_prediction/risk_prediction_page.dart';
import '../../features/safety_twin/safety_twin_page.dart';
import '../../features/situation_report/situation_report_page.dart';
import '../../features/trust_center/trust_center_page.dart';
import '../../services/crisis_session_controller.dart';
import 'app_routes.dart';

GoRouter createRouter(CrisisSessionController controller) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) => AppShell(
              navigationShell: navigationShell,
              controller: controller,
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.assess,
                builder: (context, state) {
                  final q = state.uri.queryParameters['q'] ?? '';
                  return CrisisAssessmentPage(
                    controller: controller,
                    initialText: q,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.witness,
                builder: (context, state) => CrisisAssessmentPage(
                  controller: controller,
                  witnessMode: true,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.command,
                builder: (context, state) =>
                    RescueCommandPage(controller: controller),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.riskPredict,
                builder: (context, state) => const RiskPredictionPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.family,
                builder: (context, state) =>
                    FamilySafetyPage(controller: controller),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.industrial,
                builder: (context, state) => const IndustrialSafetyPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.twin,
                builder: (context, state) =>
                    SafetyTwinPage(controller: controller),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.report,
                builder: (context, state) =>
                    SituationReportPage(controller: controller),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.followUp,
                builder: (context, state) =>
                    IncidentFollowUpPage(controller: controller),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiLab,
                builder: (context, state) => const AiLabPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.trust,
                builder: (context, state) =>
                    TrustCenterPage(controller: controller),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('페이지를 찾을 수 없습니다')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('404 · ${state.uri}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('홈으로'),
            ),
          ],
        ),
      ),
    ),
  );
}
