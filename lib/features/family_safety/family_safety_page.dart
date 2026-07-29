import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/profile_models.dart';
import '../../services/crisis_session_controller.dart';
import '../../shared/widgets/common_widgets.dart';

class FamilySafetyPage extends StatefulWidget {
  const FamilySafetyPage({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  State<FamilySafetyPage> createState() => _FamilySafetyPageState();
}

class _FamilySafetyPageState extends State<FamilySafetyPage> {
  bool _consent = false;

  @override
  void initState() {
    super.initState();
    _consent = widget.controller.profile.consentGiven;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final family = widget.controller.family;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(
                    title: '가족·고령자 안전 연결',
                    subtitle:
                        '안부 확인 시나리오와 보호자 연락 순서를 준비합니다. 외부 전송은 하지 않으며 브라우저 로컬에만 저장됩니다.',
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _consent,
                    onChanged: (v) => setState(() => _consent = v ?? false),
                    title: const Text('민감정보 로컬 저장에 동의합니다. 언제든 삭제할 수 있습니다.'),
                  ),
                  const SizedBox(height: 8),
                  if (!_consent)
                    const Text('동의 전에는 가족 카드를 저장하지 않습니다.')
                  else ...[
                    FilledButton.icon(
                      onPressed: _addMember,
                      icon: const Icon(Icons.add),
                      label: const Text('가족 안전카드 추가'),
                    ),
                    const SizedBox(height: 12),
                    for (final m in family) _memberTile(m),
                    const SizedBox(height: 16),
                    const Text(
                      '응답 없음 단계별 대응 (샘플)',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const Text(
                      '1) 전화 확인 → 2) 보호자·이웃 확인 → 3) 안전 시 방문 → 4) 위험징후/지속 무응답 시 상향',
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () async {
                        await widget.controller.saveFamily([]);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('가족 데이터를 삭제했습니다.')),
                          );
                        }
                      },
                      child: const Text('가족 데이터 삭제'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _memberTile(FamilyMemberCard m) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${m.name} (${m.relation})'),
      subtitle: Text(
        '마지막 확인: ${m.lastCheckAt?.toLocal().toString() ?? '없음'}\n'
        '패턴: ${m.usualPattern.isEmpty ? '미입력' : m.usualPattern}\n'
        '연락순서: ${m.contactOrder.isEmpty ? '미입력' : m.contactOrder}',
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(Icons.verified_user_outlined),
        tooltip: '지금 확인함',
        onPressed: () async {
          m.lastCheckAt = DateTime.now();
          await widget.controller.saveFamily([...widget.controller.family]);
        },
      ),
    );
  }

  Future<void> _addMember() async {
    final name = TextEditingController();
    final relation = TextEditingController();
    final pattern = TextEditingController();
    final order = TextEditingController();
    final meds = TextEditingController();
    final allergy = TextEditingController();
    final mobility = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('가족 안전카드'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: '이름/호칭'),
              ),
              TextField(
                controller: relation,
                decoration: const InputDecoration(labelText: '관계'),
              ),
              TextField(
                controller: pattern,
                decoration: const InputDecoration(labelText: '평소 생활 패턴'),
              ),
              TextField(
                controller: order,
                decoration: const InputDecoration(labelText: '보호자 연락 순서'),
              ),
              TextField(
                controller: meds,
                decoration: const InputDecoration(labelText: '복용약 메모'),
              ),
              TextField(
                controller: allergy,
                decoration: const InputDecoration(labelText: '알레르기'),
              ),
              TextField(
                controller: mobility,
                decoration: const InputDecoration(labelText: '이동제약'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (ok == true && name.text.trim().isNotEmpty) {
      final card = FamilyMemberCard(
        id: const Uuid().v4(),
        name: name.text.trim(),
        relation: relation.text.trim(),
        usualPattern: pattern.text.trim(),
        contactOrder: order.text.trim(),
        medicationsNote: meds.text.trim(),
        allergyNote: allergy.text.trim(),
        mobilityNote: mobility.text.trim(),
        lastCheckAt: DateTime.now(),
      );
      final profile = widget.controller.profile..consentGiven = true;
      await widget.controller.saveProfile(profile);
      await widget.controller.saveFamily([...widget.controller.family, card]);
    }
  }
}
