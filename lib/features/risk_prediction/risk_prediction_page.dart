import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/profile_models.dart';
import '../../services/engines/risk_prediction_engine.dart';
import '../../shared/widgets/common_widgets.dart';

class RiskPredictionPage extends StatefulWidget {
  const RiskPredictionPage({super.key});

  @override
  State<RiskPredictionPage> createState() => _RiskPredictionPageState();
}

class _RiskPredictionPageState extends State<RiskPredictionPage> {
  SensorSnapshot _snapshot = const SensorSnapshot();
  final _engine = RiskPredictionEngine();

  @override
  Widget build(BuildContext context) {
    final results = _engine.predict(_snapshot);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                title: 'AI 위험예측센터',
                subtitle:
                    '재난 목록이 아니라, 위험이 커지기 전에 샘플 센서·활동 데이터를 어떻게 분석하는지 보여줍니다. 현재는 시뮬레이터입니다.',
              ),
              const SizedBox(height: 12),
              const SafetyDisclaimerBanner(compact: true),
              const SizedBox(height: 16),
              Text(
                '샘플 입력',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              _slider(
                '평소 활동 시작 시각(시)',
                _snapshot.usualActivityStartHour.toDouble(),
                0,
                23,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(
                    usualActivityStartHour: v.round(),
                  ),
                ),
              ),
              _slider(
                '마지막 움직임(분 전)',
                _snapshot.lastMotionMinutesAgo.toDouble(),
                0,
                360,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(
                    lastMotionMinutesAgo: v.round(),
                  ),
                ),
              ),
              _slider(
                '현재 온도(°C)',
                _snapshot.temperatureC,
                -15,
                45,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(temperatureC: v),
                ),
              ),
              _slider(
                '연기센서',
                _snapshot.smokeSensor,
                0,
                100,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(smokeSensor: v),
                ),
              ),
              _slider(
                '가스센서',
                _snapshot.gasSensor,
                0,
                100,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(gasSensor: v),
                ),
              ),
              _slider(
                '설비 전류(A)',
                _snapshot.equipmentCurrent,
                0,
                50,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(equipmentCurrent: v),
                ),
              ),
              _slider(
                '평상시 전류(A)',
                _snapshot.usualCurrent,
                0,
                50,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(usualCurrent: v),
                ),
              ),
              _slider(
                '하천 수위 변화(cm)',
                _snapshot.riverLevelDeltaCm,
                0,
                200,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(riverLevelDeltaCm: v),
                ),
              ),
              _slider(
                '위치 정지(분)',
                _snapshot.locationStationaryMinutes.toDouble(),
                0,
                480,
                (v) => setState(
                  () => _snapshot = _snapshot.copyWith(
                    locationStationaryMinutes: v.round(),
                  ),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('작업자 위험구역 진입'),
                value: _snapshot.workerInHazardZone,
                onChanged: (v) => setState(
                  () => _snapshot = _snapshot.copyWith(workerInHazardZone: v),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '예측 결과',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              for (final r in results)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 4,
                          color: _colorFor(r.levelLabel),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${r.domain} · ${r.levelLabel}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '판단 근거',
                            style: TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          for (final reason in r.reasons) Text('· $reason'),
                          Text('권고: ${r.recommendedAction}'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(0)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Color _colorFor(String label) {
    switch (label) {
      case '공식 구조 요청 검토':
        return AppColors.danger;
      case '즉시 현장 확인 필요':
        return const Color(0xFFD84315);
      case '확인 요청':
      case '관찰 필요':
        return AppColors.amber;
      default:
        return AppColors.teal;
    }
  }
}
