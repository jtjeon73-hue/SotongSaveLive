import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/enums.dart';

class SafetyDisclaimerBanner extends StatelessWidget {
  const SafetyDisclaimerBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '안전 고지',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? 10 : 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F2F8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF9BB6C9)),
        ),
        child: Text(
          'SotongSaveLive는 의료진·구조대·경찰을 대신하지 않습니다. '
          '생명이 위급하면 즉시 공식 긴급구조에 연결하세요. '
          'AI는 상황 파악과 행동 계획을 돕는 보조 도구입니다.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: compact ? 13 : 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.level});

  final RiskLevel level;

  Color get _color {
    switch (level) {
      case RiskLevel.critical:
        return const Color(0xFFC62828);
      case RiskLevel.high:
        return const Color(0xFFD84315);
      case RiskLevel.moderate:
        return const Color(0xFFC98500);
      case RiskLevel.low:
        return const Color(0xFF0F8B7B);
      case RiskLevel.unknown:
        return const Color(0xFF5B6B7C);
    }
  }

  IconData get _icon {
    switch (level) {
      case RiskLevel.critical:
      case RiskLevel.high:
        return Icons.warning_amber_rounded;
      case RiskLevel.moderate:
        return Icons.priority_high;
      case RiskLevel.low:
        return Icons.check_circle_outline;
      case RiskLevel.unknown:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '위험도 ${level.labelKo}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: _color, size: 20),
            const SizedBox(width: 8),
            Text(
              '위험도: ${level.labelKo}',
              style: TextStyle(
                color: _color,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComingSoonChip extends StatelessWidget {
  const ComingSoonChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.schedule, size: 16),
      label: Text('$label · 향후 연결 예정'),
      visualDensity: VisualDensity.compact,
    );
  }
}

Future<void> openExternalSafely(String url) async {
  final uri = Uri.parse(url);
  if (!await canLaunchUrl(uri)) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0B1F33),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF5B6B7C),
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
