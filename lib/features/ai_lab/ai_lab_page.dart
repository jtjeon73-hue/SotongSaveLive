import 'package:flutter/material.dart';

import '../../shared/widgets/common_widgets.dart';

class AiLabPage extends StatelessWidget {
  const AiLabPage({super.key});

  static const _techs = <_Tech>[
    _Tech(
      name: '멀티모달 상황인식',
      problem: '말·글·이미지·센서가 흩어져 위기 파악이 늦어짐',
      data: '텍스트, 향후 음성·사진·센서',
      aiJudges: '가장 위험한 신호와 부족한 정보',
      humanChecks: '현장 안전과 공식 구조 필요성',
      risk: '오인식·편향',
      stage: '1단계: 텍스트 규칙 / 향후 멀티모달',
      effect: '상황 설명 부담 감소',
    ),
    _Tech(
      name: '음성 스트레스·호흡 이상 보조분석',
      problem: '호흡 곤란·긴장 상태를 놓치기 쉬움',
      data: '음성 파형(향후)',
      aiJudges: '추가 확인이 필요한 음성 신호',
      humanChecks: '실제 호흡·의식',
      risk: '환경소음 오판',
      stage: '향후 연결 예정',
      effect: '조기 주의 환기',
    ),
    _Tech(
      name: '컴퓨터 비전 낙상·화재·침수 감지',
      problem: '无人 감시 공백',
      data: '카메라/CCTV(향후)',
      aiJudges: '이상 장면 후보',
      humanChecks: '오탐 확인 후 출동',
      risk: '프라이버시·오탐',
      stage: '향후',
      effect: '무응답·화재 조기 발견',
    ),
    _Tech(
      name: '시계열 이상탐지',
      problem: '평소와 다른 무활동·전류·수위 변화',
      data: '활동·센서 시계열',
      aiJudges: '관찰/확인/즉시확인 단계',
      humanChecks: '현장·연락 확인',
      risk: '패턴 변화 오인',
      stage: '1단계 샘플 시뮬레이터',
      effect: '사전 위험 상승 감지',
    ),
    _Tech(
      name: '위치·기상·지형 결합분석',
      problem: '폭염·산불·침수 맥락 부족',
      data: '위치·기상·지형(향후)',
      aiJudges: '환경 위험 가중',
      humanChecks: '대피 가능 방향',
      risk: '위치 오류',
      stage: '인터페이스만 준비',
      effect: '환경형 위기 대응력',
    ),
    _Tech(
      name: 'RAG와 공식 근거 관리',
      problem: '검증되지 않은 지침 확산',
      data: '공식 기관 문서 메타데이터',
      aiJudges: '근거가 있는 안내만 우선',
      humanChecks: '전문 검토 필요 표시',
      risk: '낡은 문서',
      stage: '1단계 출처 정책·메타 구조',
      effect: '신뢰성 향상',
    ),
    _Tech(
      name: '웨어러블 연동',
      problem: '혼자 있는 고령자·작업자 상태 공백',
      data: '심박·활동(향후)',
      aiJudges: '무활동·이상 후보',
      humanChecks: '오경보 확인',
      risk: '기기 미착용',
      stage: '향후',
      effect: '독거·현장 보호',
    ),
    _Tech(
      name: 'PLC·IoT·Modbus 연동',
      problem: '설비 이상과 사람 위험의 단절',
      data: '전류·가스·연기·가동상태',
      aiJudges: '안전정지·확인 필요성',
      humanChecks: '설비 잠금·현장 안전',
      risk: '센서 고장',
      stage: '1단계 데모 + 연동 구상',
      effect: '산업·농촌 차별화',
    ),
    _Tech(
      name: '엣지 AI와 오프라인 작동',
      problem: '통신 불능 현장',
      data: '로컬 규칙/모델',
      aiJudges: '최소 안전 행동',
      humanChecks: '통신 복구 후 공유',
      risk: '모델 업데이트 지연',
      stage: '로컬 엔진으로 시작',
      effect: '농촌·현장 가용성',
    ),
    _Tech(
      name: '보호자·관리자·구조기관 에이전트',
      problem: '전달 내용이 불명확',
      data: '상황보고서',
      aiJudges: '역할별 요약',
      humanChecks: '전송 전 개인정보 확인',
      risk: '과도한 자동화',
      stage: '1단계 복사/요약만',
      effect: '전달 속도·정확도',
    ),
    _Tech(
      name: 'Human-in-the-loop',
      problem: 'AI 단독 결정 위험',
      data: '사용자 답변·완료/불가',
      aiJudges: '제안',
      humanChecks: '최종 행동·구조 요청',
      risk: '자동화 과신',
      stage: '전 화면 적용',
      effect: '안전장치',
    ),
    _Tech(
      name: '설명 가능한 AI',
      problem: '왜 위험한지 모름',
      data: '적용 규칙·요인',
      aiJudges: '근거 있는 위험도',
      humanChecks: '근거 검토',
      risk: '규칙 과단순',
      stage: '판단 근거 표시',
      effect: '신뢰·수정 가능',
    ),
    _Tech(
      name: '오판·편향·개인정보 보호',
      problem: '잘못된 확신·유출',
      data: '최소 수집 로컬 데이터',
      aiJudges: '불확실성 유지',
      humanChecks: '삭제·동의',
      risk: '잔여 편향',
      stage: '확인불가≠안전, 진단 금지',
      effect: '피해 최소화',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _techs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: SectionHeader(
              title: 'AI 생명구조 기술연구소',
              subtitle: 'SotongSaveLive에 실제로 적용할 기술과 구현 단계를 구체적으로 설명합니다.',
            ),
          );
        }
        final t = _techs[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              Text('문제: ${t.problem}'),
              Text('데이터: ${t.data}'),
              Text('AI 판단: ${t.aiJudges}'),
              Text('사람 확인: ${t.humanChecks}'),
              Text('오판·안전장치: ${t.risk}'),
              Text('구현 단계: ${t.stage}'),
              Text('기대효과: ${t.effect}'),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}

class _Tech {
  const _Tech({
    required this.name,
    required this.problem,
    required this.data,
    required this.aiJudges,
    required this.humanChecks,
    required this.risk,
    required this.stage,
    required this.effect,
  });

  final String name;
  final String problem;
  final String data;
  final String aiJudges;
  final String humanChecks;
  final String risk;
  final String stage;
  final String effect;
}
