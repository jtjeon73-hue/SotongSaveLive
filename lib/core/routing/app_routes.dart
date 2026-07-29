import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/';
  static const fiveLives = '/five-lives';
  static const roadmap = '/roadmap';
  static const moneyWork = '/money-work';
  static const healthLife = '/health-life';
  static const rural = '/rural';
  static const legacy = '/legacy';

  static String lifeDetail(String type) => '/five-lives/$type';

  static const destinations = <({String path, String label, IconData icon})>[
    (path: home, label: '홈', icon: Icons.home_outlined),
    (path: fiveLives, label: '다섯 가지 인생', icon: Icons.diversity_3_outlined),
    (path: roadmap, label: 'AI 인생로드맵', icon: Icons.timeline_outlined),
    (
      path: moneyWork,
      label: '돈과 평생일',
      icon: Icons.account_balance_wallet_outlined,
    ),
    (path: healthLife, label: '건강·관계·생활', icon: Icons.favorite_outline),
    (path: rural, label: '농촌과 제2의 인생', icon: Icons.agriculture_outlined),
    (path: legacy, label: '아름다운 마무리', icon: Icons.spa_outlined),
  ];
}
