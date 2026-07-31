import 'package:flutter/material.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';

class SotongApp extends StatelessWidget {
  const SotongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '소통노후 | 노후 지식 전문관',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: createRouter(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.35),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
