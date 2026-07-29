import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotong_save_live/app/sotong_app.dart';
import 'package:sotong_save_live/core/routing/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const SotongApp());
    await tester.pumpAndSettle();
  }

  testWidgets('홈에서 다섯 가지 인생으로 이동', (tester) async {
    await pumpApp(tester);
    expect(find.textContaining('나답게'), findsWidgets);

    final menu = find.byTooltip('메뉴');
    if (menu.evaluate().isNotEmpty) {
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('다섯 가지 인생'));
      await tester.pumpAndSettle();
    } else {
      await tester.tap(find.text('다섯 가지 인생').first);
      await tester.pumpAndSettle();
    }
    expect(find.textContaining('다섯 가지 인생'), findsWidgets);
  });

  testWidgets('인생 유형 상세화면 이동', (tester) async {
    await pumpApp(tester);
    final menu = find.byTooltip('메뉴');
    if (menu.evaluate().isNotEmpty) {
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('다섯 가지 인생'));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.text('이 인생 자세히 읽기').first);
    await tester.tap(find.text('이 인생 자세히 읽기').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('AI 인생분석'), findsWidgets);
  });

  testWidgets('연령대별 로드맵 전환', (tester) async {
    await pumpApp(tester);
    final menu = find.byTooltip('메뉴');
    if (menu.evaluate().isNotEmpty) {
      await tester.tap(menu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('AI 인생로드맵'));
      await tester.pumpAndSettle();
    } else {
      await tester.tap(find.text('AI 인생로드맵').first);
      await tester.pumpAndSettle();
    }
    expect(find.textContaining('인생로드맵'), findsWidgets);
    final chip = find.byType(ChoiceChip).at(1);
    await tester.tap(chip);
    await tester.pumpAndSettle();
    expect(find.textContaining('시나리오'), findsWidgets);
  });

  testWidgets('아름다운 마무리 화면 접근', (tester) async {
    await pumpApp(tester);
    final ctx = tester.element(find.byType(Scaffold).first);
    GoRouter.of(ctx).go(AppRoutes.legacy);
    await tester.pumpAndSettle();
    expect(find.textContaining('사전연명의료의향서'), findsWidgets);
  });

  testWidgets('입력 필드가 없다', (tester) async {
    await pumpApp(tester);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(TextFormField), findsNothing);
    expect(find.byType(EditableText), findsNothing);
  });

  testWidgets('모바일 오버플로 없음', (tester) async {
    final overflows = <FlutterErrorDetails>[];
    final old = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.toString().contains('overflowed')) overflows.add(d);
      old?.call(d);
    };
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      FlutterError.onError = old;
    });
    await pumpApp(tester);
    expect(overflows, isEmpty);
  });
}
