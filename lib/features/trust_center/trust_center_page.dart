import 'package:flutter/material.dart';

import '../../data/official_sources.dart';
import '../../services/crisis_session_controller.dart';
import '../../shared/widgets/common_widgets.dart';

class TrustCenterPage extends StatelessWidget {
  const TrustCenterPage({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                title: '신뢰·안전·출처',
                subtitle: 'AI가 할 수 있는 것과 해서는 안 되는 것을 분명히 합니다.',
              ),
              const SizedBox(height: 12),
              const SafetyDisclaimerBanner(),
              const SizedBox(height: 16),
              const Text(
                'AI가 할 수 있는 것',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Text('· 위기 상황의 부족한 정보를 단계적으로 질문'),
              const Text('· 생명위험 가능성을 보수적으로 판별'),
              const Text('· 행동계획·금지행동·전달문·추적 계획 구성'),
              const SizedBox(height: 12),
              const Text(
                'AI가 해서는 안 되는 것',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Text('· 의료진·구조대·경찰을 대신한다고 표현'),
              const Text('· 질환 확정 진단, 약물·용량 지시'),
              const Text('· 생존율 등 근거 없는 백분율 예측'),
              const Text('· 확인되지 않은 전화번호·기관 생성'),
              const SizedBox(height: 12),
              const Text(
                '개인정보 처리 원칙',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Text('· 1단계: 브라우저 로컬 저장만, 외부 전송 없음'),
              const Text('· 민감정보 저장 전 동의, 언제든 전체 삭제'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  await controller.clearAllData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('브라우저 저장 데이터를 모두 삭제했습니다.')),
                    );
                  }
                },
                child: const Text('브라우저 저장 데이터 전체 삭제'),
              ),
              const SizedBox(height: 16),
              const Text(
                '근거 출처 범주',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              for (final s in OfficialSources.categories)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.agency),
                  subtitle: Text('${s.documentTitle}\n검토상태: ${s.reviewStatus}'),
                  isThreeLine: true,
                  trailing: s.url == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () => openExternalSafely(s.url!),
                        ),
                ),
              const Text('콘텐츠 검토일: 2026-07-29'),
              const Text('공식 기관 자료 우선. 미확인 내용은 전문 검토 필요로 표시합니다.'),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '잘못된 결과 신고 (로컬 메모)',
                  hintText: '어떤 판단이 문제였는지 적어 주세요. 외부 전송되지 않습니다.',
                ),
                minLines: 2,
                maxLines: 4,
                onSubmitted: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('신고 메모는 이 세션에만 남습니다. 외부 전송 기능은 없습니다.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
