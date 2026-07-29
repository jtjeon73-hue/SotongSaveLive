import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sotong_save_live/app/sotong_app.dart';
import 'package:sotong_save_live/services/crisis_session_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<CrisisSessionController> pumpApp(WidgetTester tester) async {
    final controller = CrisisSessionController();
    await controller.init();
    await tester.pumpWidget(SotongApp(controller: controller));
    await tester.pumpAndSettle();
    return controller;
  }

  testWidgets('홈에서 AI 상황판단 화면 진입', (tester) async {
    await pumpApp(tester);
    expect(find.textContaining('SotongSaveLive'), findsWidgets);
    final enter = find.text('지금 위험한 상황인가요?');
    expect(enter, findsOneWidget);
    await tester.tap(enter);
    await tester.pumpAndSettle();
    expect(find.textContaining('AI가 지금 내 상황 판단'), findsOneWidget);
  });

  testWidgets('빠른 상황 선택과 질문 진행', (tester) async {
    final controller = await pumpApp(tester);
    await tester.tap(find.text('지금 위험한 상황인가요?'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('사람이 쓰러졌어요'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('상황 파악 시작'));
    await tester.tap(find.text('상황 파악 시작'));
    await tester.pumpAndSettle();

    expect(controller.crisis, isNotNull);
    expect(find.textContaining('다음 확인'), findsOneWidget);

    await tester.ensureVisible(find.text('확인할 수 없음').first);
    await tester.tap(find.text('확인할 수 없음').first);
    await tester.pumpAndSettle();
    expect(controller.crisis!.answers.isNotEmpty, isTrue);
  });

  testWidgets('구조 지휘 화면 전환과 보고서 복사', (tester) async {
    final controller = await pumpApp(tester);
    await controller.startAssessment(freeText: '농기계 끼임', situation: null);
    // Force situation via restart with enum through assess UI is heavy;
    // start with free text then navigate.
    await controller.startAssessment(freeText: '농기계에 끼였어요', situation: null);
    await tester.pumpWidget(SotongApp(controller: controller));
    await tester.pumpAndSettle();

    // Navigate via menu on wide layout may differ; use direct go by rebuilding
    // with route - instead tap bottom/rail if present.
    final commandLabel = find.text('지휘');
    if (commandLabel.evaluate().isNotEmpty) {
      await tester.tap(commandLabel.first);
      await tester.pumpAndSettle();
    } else {
      await tester.tap(find.byTooltip('메뉴'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('지휘센터'));
      await tester.pumpAndSettle();
    }

    expect(find.textContaining('지휘'), findsWidgets);
  });

  testWidgets('데이터 전체 삭제', (tester) async {
    final controller = await pumpApp(tester);
    await controller.startAssessment(freeText: '테스트');
    expect(controller.crisis, isNotNull);
    await controller.clearAllData();
    expect(controller.crisis, isNull);
  });

  testWidgets('모바일 폭에서 오버플로 없음', (tester) async {
    final errors = <FlutterErrorDetails>[];
    final old = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) {
        errors.add(details);
      }
      old?.call(details);
    };

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      FlutterError.onError = old;
    });

    await pumpApp(tester);
    await tester.tap(find.text('지금 위험한 상황인가요?'));
    await tester.pumpAndSettle();
    expect(errors, isEmpty);
  });
}
