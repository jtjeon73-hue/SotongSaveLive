import 'package:flutter/material.dart';

import '../../models/profile_models.dart';
import '../../services/crisis_session_controller.dart';
import '../../shared/widgets/common_widgets.dart';

class SafetyTwinPage extends StatefulWidget {
  const SafetyTwinPage({super.key, required this.controller});

  final CrisisSessionController controller;

  @override
  State<SafetyTwinPage> createState() => _SafetyTwinPageState();
}

class _SafetyTwinPageState extends State<SafetyTwinPage> {
  late SafetyProfile _p;
  bool _consent = false;

  @override
  void initState() {
    super.initState();
    _p = widget.controller.profile;
    _consent = _p.consentGiven;
  }

  @override
  Widget build(BuildContext context) {
    final plan = _buildPlan(_p);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                title: '나의 생명안전 디지털 트윈',
                subtitle: '민감정보는 최소한으로 받고, 동의 후 로컬에만 저장합니다. 언제든 전체 삭제할 수 있습니다.',
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _consent,
                onChanged: (v) => setState(() => _consent = v ?? false),
                title: const Text('로컬 저장에 동의합니다'),
              ),
              DropdownButtonFormField<String>(
                // ignore: deprecated_member_use
                value: _p.ageBand.isEmpty ? null : _p.ageBand,
                decoration: const InputDecoration(labelText: '연령대'),
                items: const [
                  DropdownMenuItem(value: '청년', child: Text('청년')),
                  DropdownMenuItem(value: '중장년', child: Text('중장년')),
                  DropdownMenuItem(value: '고령', child: Text('고령')),
                ],
                onChanged: (v) => setState(() => _p.ageBand = v ?? ''),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('복용 중인 약 있음'),
                value: _p.hasMedications,
                onChanged: (v) => setState(() => _p.hasMedications = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('보행 제약'),
                value: _p.mobilityLimit,
                onChanged: (v) => setState(() => _p.mobilityLimit = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('농장·공장 활동'),
                value: _p.farmOrFactory,
                onChanged: (v) => setState(() => _p.farmOrFactory = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('산악활동'),
                value: _p.mountainActivity,
                onChanged: (v) => setState(() => _p.mountainActivity = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('차량 있음'),
                value: _p.hasVehicle,
                onChanged: (v) => setState(() => _p.hasVehicle = v),
              ),
              TextFormField(
                initialValue: _p.allergies,
                decoration: const InputDecoration(labelText: '알레르기(선택)'),
                onChanged: (v) => _p.allergies = v,
              ),
              TextFormField(
                initialValue: _p.guardianOrder,
                decoration: const InputDecoration(labelText: '보호자 연락 순서'),
                onChanged: (v) => _p.guardianOrder = v,
              ),
              TextFormField(
                initialValue: _p.emergencyNeeds,
                decoration: const InputDecoration(labelText: '비상시 도움이 필요한 사항'),
                onChanged: (v) => _p.emergencyNeeds = v,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: !_consent
                    ? null
                    : () async {
                        _p.consentGiven = true;
                        await widget.controller.saveProfile(_p);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('로컬에 저장했습니다.')),
                          );
                        }
                        setState(() {});
                      },
                child: const Text('저장'),
              ),
              OutlinedButton(
                onPressed: () async {
                  await widget.controller.clearAllData();
                  setState(() {
                    _p = SafetyProfile();
                    _consent = false;
                  });
                },
                child: const Text('전체 데이터 삭제'),
              ),
              const SizedBox(height: 20),
              const Text(
                'AI 생성 준비 결과',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              for (final line in plan) Text('· $line'),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _buildPlan(SafetyProfile p) {
    final out = <String>[
      '개인별 위험요인: ${[if (p.ageBand == '고령') '고령 관련 낙상·무응답', if (p.farmOrFactory) '농기계·산업현장 위험', if (p.mountainActivity) '조난·위치 정지', if (p.mobilityLimit) '이동 제약 시 대피 지원 필요', if (p.hasMedications) '약 복용 정보 사전 공유'].join(', ').ifEmpty('기본 생활안전')}',
      '사전 준비목록: 비상연락망, 전달문 템플릿, ${p.hasVehicle ? '차량 대피 경로' : '도보·동행 대피 계획'}',
      '위기상황별 우선 행동: 생명위험 신호 확인 → 공식 도움 요청 → 안전 장소 확보',
      '보호자에게 미리 알려둘 내용: ${p.guardianOrder.ifEmpty('연락 순서 미입력')} / ${p.emergencyNeeds.ifEmpty('비상 도움 사항 미입력')}',
      '월간 안전점검: 연락망 시험, 센서/경보 점검, 약·알레르기 메모 갱신',
    ];
    return out;
  }
}

extension on String {
  String ifEmpty(String fallback) => trim().isEmpty ? fallback : this;
}
