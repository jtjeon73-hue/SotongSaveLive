import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/profile_models.dart';
import '../../services/engines/risk_prediction_engine.dart';
import '../../shared/widgets/common_widgets.dart';

class IndustrialSafetyPage extends StatefulWidget {
  const IndustrialSafetyPage({super.key});

  @override
  State<IndustrialSafetyPage> createState() => _IndustrialSafetyPageState();
}

class _IndustrialSafetyPageState extends State<IndustrialSafetyPage> {
  SensorSnapshot _s = const SensorSnapshot(
    equipmentCurrent: 12,
    usualCurrent: 10,
    temperatureC: 33,
  );
  final _engine = RiskPredictionEngine();

  @override
  Widget build(BuildContext context) {
    final results = _engine.predict(_s);
    final top = results.where((r) => r.levelLabel != '정상').toList()
      ..sort((a, b) => _rank(b.levelLabel).compareTo(_rank(a.levelLabel)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                title: '농촌·산업현장 생명관제',
                subtitle:
                    '센서 감지 → AI 이상판단 → 사람 확인 → 설비 안전정지 검토 → 보호자·관리자 알림 → 구조 연결 → 사건기록',
              ),
              const SizedBox(height: 12),
              const SafetyDisclaimerBanner(compact: true),
              const SizedBox(height: 16),
              const Text(
                '샘플 센서 데모',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Slider(
                value: _s.equipmentCurrent,
                min: 0,
                max: 40,
                label: '전류 ${_s.equipmentCurrent.toStringAsFixed(0)}A',
                onChanged: (v) =>
                    setState(() => _s = _s.copyWith(equipmentCurrent: v)),
              ),
              Slider(
                value: _s.smokeSensor,
                min: 0,
                max: 100,
                label: '연기 ${_s.smokeSensor.toStringAsFixed(0)}',
                onChanged: (v) =>
                    setState(() => _s = _s.copyWith(smokeSensor: v)),
              ),
              Slider(
                value: _s.gasSensor,
                min: 0,
                max: 100,
                label: '가스 ${_s.gasSensor.toStringAsFixed(0)}',
                onChanged: (v) =>
                    setState(() => _s = _s.copyWith(gasSensor: v)),
              ),
              Slider(
                value: _s.temperatureC,
                min: 0,
                max: 45,
                label: '온도 ${_s.temperatureC.toStringAsFixed(0)}°C',
                onChanged: (v) =>
                    setState(() => _s = _s.copyWith(temperatureC: v)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('농기계/작업자 위험구역 접근'),
                value: _s.workerInHazardZone,
                onChanged: (v) =>
                    setState(() => _s = _s.copyWith(workerInHazardZone: v)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.navy.withValues(alpha: 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      top.isEmpty
                          ? '현재 이상 신호 낮음 (샘플)'
                          : '이상판단: ${top.first.domain} · ${top.first.levelLabel}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('흐름'),
                    const Text(
                      '1 센서 감지 → 2 AI 이상판단 → 3 사람 확인 → 4 설비 안전정지 검토 → '
                      '5 보호자·관리자 알림 → 6 구조 연결 → 7 사건기록',
                    ),
                    if (top.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        '판단 근거',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      for (final r in top.take(3)) ...[
                        Text('· ${r.domain}: ${r.reasons.join(' / ')}'),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '연동 구상 (1단계: 인터페이스만)',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Text('· PLC·센서 연동 / MFC 관제 프로그램'),
              const Text('· Modbus RTU/TCP 데이터 수집'),
              const Text('· 로컬 PC 기반 오프라인 관제'),
              const Text('· 감전·추락·밀폐공간·산불·농약 중독 시나리오 확장'),
              const SizedBox(height: 8),
              const ComingSoonChip(label: '실제 PLC·Modbus 연결'),
            ],
          ),
        ),
      ),
    );
  }

  int _rank(String label) {
    switch (label) {
      case '공식 구조 요청 검토':
        return 5;
      case '즉시 현장 확인 필요':
        return 4;
      case '확인 요청':
        return 3;
      case '관찰 필요':
        return 2;
      default:
        return 1;
    }
  }
}
