import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../models/mind_models.dart';
import '../../services/mind_essay_repository.dart';
import '../../shared/widgets/common_widgets.dart';

class MindEssayPage extends StatelessWidget {
  const MindEssayPage({super.key, required this.essay});

  final MindEssay essay;

  @override
  Widget build(BuildContext context) {
    final repo = MindEssayRepository();
    final prev = repo.previous(essay.slug);
    final next = repo.next(essay.slug);
    final related = repo.related(essay.slug);

    return PageScaffoldBody(
      maxWidth: 760,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BreadcrumbBar(
            items: [
              (label: '홈', path: AppRoutes.home),
              (label: '마음쉼터', path: AppRoutes.mindLounge),
              (label: essay.title, path: null),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            essay.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            essay.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.muted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '관련 사상·고전: ${essay.inspiration}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text('예상 읽기 시간: 약 ${essay.readingTimeMinutes}분'),
          const SizedBox(height: 8),
          Text(
            '글자 크기는 브라우저 확대/축소로 조절할 수 있습니다.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          Text(
            essay.introduction,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
          ),
          const SizedBox(height: 24),
          for (final section in essay.sections) ...[
            Text(
              section.heading,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              section.body,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.75),
            ),
            const SizedBox(height: 22),
          ],
          SoftPanel(
            accent: AppColors.gold,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘 기억할 한 문장',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  essay.rememberSentence,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SoftPanel(
            accent: AppColors.sage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '잠시 생각해 볼 내용',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(essay.reflection, style: const TextStyle(height: 1.65)),
                const SizedBox(height: 8),
                const Text(
                  '(답을 입력하는 기능은 없습니다. 마음속으로만 생각해 보세요.)',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            essay.sourceNote,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          if (related.isNotEmpty) ...[
            const Text(
              '관련 읽을거리',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 8),
            for (final r in related) ...[
              SoftPanel(
                child: InkWell(
                  onTap: () => context.go(AppRoutes.mindEssay(r.slug)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(r.subtitle),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
          SoftPanel(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: prev == null
                      ? null
                      : () => context.go(AppRoutes.mindEssay(prev.slug)),
                  child: Text(
                    prev == null ? '이전 글 없음' : '이전 · ${prev.title}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.mindLounge),
                  child: const Text('마음쉼터 전체보기'),
                ),
                OutlinedButton(
                  onPressed: next == null
                      ? null
                      : () => context.go(AppRoutes.mindEssay(next.slug)),
                  child: Text(
                    next == null ? '다음 글 없음' : '다음 · ${next.title}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}
