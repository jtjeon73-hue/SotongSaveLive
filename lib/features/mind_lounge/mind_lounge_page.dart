import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../services/mind_essay_repository.dart';
import '../../shared/widgets/common_widgets.dart';

class MindLoungePage extends StatelessWidget {
  const MindLoungePage({super.key});

  @override
  Widget build(BuildContext context) {
    final essays = MindEssayRepository().all;
    return PageScaffoldBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(
            title: '마음쉼터',
            subtitle: '마음이 복잡한 날, 조용히 읽으며 나를 돌아보는 시간',
          ),
          const SizedBox(height: 8),
          SoftPanel(
            accent: AppColors.sage,
            child: const Text(
              '특정 종교를 강요하거나 설교하는 공간이 아닙니다. '
              '불교·유교·도교·스토아 철학과 인생 경험이 남긴 지혜를 '
              '종교와 관계없이 편안하게 읽을 수 있도록 구성했습니다. '
              '입력·설문·댓글·로그인 기능은 없습니다.',
            ),
          ),
          const SizedBox(height: 16),
          for (final e in essays) ...[
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(e.subtitle),
                  const SizedBox(height: 8),
                  Text('사상·고전: ${e.inspiration}'),
                  Text('예상 읽기 시간: 약 ${e.readingTimeMinutes}분'),
                  Text('핵심 주제: ${e.category}'),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => context.go(AppRoutes.mindEssay(e.slug)),
                    child: const Text('조용히 읽기'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          const SiteFooter(),
        ],
      ),
    );
  }
}
