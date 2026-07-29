import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 48 : 16,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.navy, AppColors.navySoft],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SotongSaveLive',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '무슨 말을 해야 할지 몰라도 괜찮습니다.\n'
                          '현재 상황을 편하게 말씀해 주세요.\n'
                          'AI가 가장 위험한 부분부터 하나씩 확인합니다.',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.95),
                                height: 1.5,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            minimumSize: const Size.fromHeight(56),
                          ),
                          onPressed: () => context.go(AppRoutes.assess),
                          icon: const Icon(Icons.emergency),
                          label: const Text('지금 위험한 상황인가요?'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SafetyDisclaimerBanner(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    title: 'AI 상황판단 바로 시작',
                    subtitle: '검색 요약이 아니라, 지금 입력한 상황에 맞춰 질문과 계획이 달라집니다.',
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _input,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: '예: 할머니가 밭에서 쓰러지셨고 말이 이상해요',
                      alignLabelWithHint: true,
                      labelText: '지금 상황을 적어 주세요',
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      context.go(
                        '${AppRoutes.assess}?q=${Uri.encodeComponent(_input.text)}',
                      );
                    },
                    child: const Text('AI가 지금 내 상황 판단'),
                  ),
                  const SizedBox(height: 28),
                  const SectionHeader(title: '입력 기능 지원 현황'),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: Icon(Icons.check, color: AppColors.teal),
                        label: Text('문장 입력 · 지원'),
                      ),
                      Chip(
                        avatar: Icon(Icons.check, color: AppColors.teal),
                        label: Text('빠른 상황 선택 · 지원'),
                      ),
                      ComingSoonChip(label: '음성'),
                      ComingSoonChip(label: '사진'),
                      ComingSoonChip(label: '위치 자동'),
                      ComingSoonChip(label: '센서·웨어러블'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const SectionHeader(
                    title: '일반 정보 사이트와 다른 점',
                    subtitle:
                        '응급처치 글을 나열하지 않습니다. 위험도 판단, 한 번에 하나씩 질문, 행동계획, 전달용 보고서, 추적까지 연결합니다.',
                  ),
                  const SizedBox(height: 16),
                  _FeatureGrid(
                    items: const [
                      ('위기 파악', '부족한 정보를 단계적으로 확인'),
                      ('위험 우선순위', '생명위험 신호를 보수적으로 상향'),
                      ('행동 지휘', '지금 할 일 하나와 금지행동'),
                      ('전달문', '구조기관·보호자용 요약'),
                      ('추적', '상태 변화와 재발방지'),
                      ('최소수집', '민감정보는 동의·삭제 가능'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '개인정보는 1단계에서 브라우저 로컬에만 저장되며 외부로 전송하지 않습니다.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items});

  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          SizedBox(
            width: 280,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.teal, width: 3),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(item.$2),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
