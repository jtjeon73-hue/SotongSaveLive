import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../models/life_models.dart';
import '../../services/life_scenario_repository.dart';
import '../../shared/widgets/common_widgets.dart';

/// Compact cross-links to retirement life paths (no input).
class RelatedLifePathsPanel extends StatelessWidget {
  const RelatedLifePathsPanel({
    super.key,
    required this.title,
    required this.links,
  });

  final String title;
  final List<({LifeTypeId id, String reason})> links;

  @override
  Widget build(BuildContext context) {
    final repo = LifeScenarioRepository();
    return SoftPanel(
      accent: AppColors.forest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (final link in links) ...[
            Builder(
              builder: (context) {
                final p = repo.byId(link.id);
                if (p == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => context.go(AppRoutes.lifeDetail(p.slug)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: const TextStyle(
                            color: AppColors.forest,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(link.reason),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
