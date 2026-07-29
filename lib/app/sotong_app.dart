import 'package:flutter/material.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../services/crisis_session_controller.dart';

class SotongApp extends StatefulWidget {
  const SotongApp({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  State<SotongApp> createState() => _SotongAppState();
}

class _SotongAppState extends State<SotongApp> {
  late final router = createRouter(widget.controller);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SotongSaveLive | AI 생명구조 플랫폼',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.4),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
