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

  BuildContext rootContext(WidgetTester tester) =>
      tester.element(find.byType(Scaffold).first);

  testWidgets('노후맞이 인생들 목록 진입', (tester) async {
    await pumpApp(tester);
    GoRouter.of(rootContext(tester)).go(AppRoutes.lifePaths);
    await tester.pumpAndSettle();
    expect(find.textContaining('노후맞이 인생들'), findsWidgets);
    expect(find.text('이 인생 살펴보기'), findsWidgets);
  });

  testWidgets('상세에서 다른 유형 칩으로 이동', (tester) async {
    await pumpApp(tester);
    final router = GoRouter.of(rootContext(tester));
    router.go(AppRoutes.lifeDetail('freelancer'));
    await tester.pumpAndSettle();
    expect(find.textContaining('다른 노후맞이 인생 보기'), findsOneWidget);
    expect(find.textContaining('프리랜서'), findsWidgets);

    await tester.ensureVisible(find.text('직장생활 후 은퇴하는 삶').first);
    await tester.tap(find.text('직장생활 후 은퇴하는 삶').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('직장생활 후 은퇴'), findsWidgets);
  });

  testWidgets('breadcrumb로 전체 목록 복귀', (tester) async {
    await pumpApp(tester);
    GoRouter.of(rootContext(tester)).go(AppRoutes.lifeDetail('rural-life'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('노후맞이 인생들').first);
    await tester.pumpAndSettle();
    expect(find.text('이 인생 살펴보기'), findsWidgets);
  });

  testWidgets('마음쉼터 목록과 상세', (tester) async {
    await pumpApp(tester);
    GoRouter.of(rootContext(tester)).go(AppRoutes.mindLounge);
    await tester.pumpAndSettle();
    expect(find.textContaining('마음쉼터'), findsWidgets);
    expect(find.text('조용히 읽기'), findsWidgets);

    GoRouter.of(rootContext(tester)).go(AppRoutes.mindEssay('today-remains'));
    await tester.pumpAndSettle();
    expect(find.textContaining('오늘 기억할 한 문장'), findsOneWidget);
    expect(find.textContaining('잠시 생각해 볼 내용'), findsOneWidget);
  });

  testWidgets('잘못된 slug는 목록 안내', (tester) async {
    await pumpApp(tester);
    GoRouter.of(rootContext(tester)).go(AppRoutes.lifeDetail('no-such-type'));
    await tester.pumpAndSettle();
    expect(find.textContaining('찾을 수 없습니다'), findsWidgets);
    expect(find.text('노후맞이 인생들 전체보기'), findsOneWidget);
  });

  testWidgets('입력 필드가 없다', (tester) async {
    await pumpApp(tester);
    GoRouter.of(rootContext(tester)).go(AppRoutes.lifePaths);
    await tester.pumpAndSettle();
    GoRouter.of(rootContext(tester)).go(AppRoutes.mindLounge);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(TextFormField), findsNothing);
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
    GoRouter.of(rootContext(tester)).go(AppRoutes.lifeDetail('solo-household'));
    await tester.pumpAndSettle();
    expect(overflows, isEmpty);
  });
}
