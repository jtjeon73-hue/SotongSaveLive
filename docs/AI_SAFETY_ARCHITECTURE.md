# AI 안전 아키텍처

## 원칙

1. Human-in-the-loop: 최종 행동과 구조 요청은 사람
2. 확인 불가 ≠ 안전
3. 생명위험 신호 1개만 있어도 보수적 상향
4. 설명 가능성: 적용 규칙·판단 근거 표시
5. 진단·약물 용량·가짜 연락처 금지
6. 최소수집·동의·삭제

## 1단계 구성

```
UI (features/*)
  → CrisisSessionController
    → LifeSafetyOrchestrator
      → RiskAssessmentEngine
      → SituationQuestionEngine
      → ActionPlanEngine
      → SafetyReportGenerator
      → FollowUpEngine
      → PreventionPlanEngine
```

화면과 판단 로직을 분리했습니다. 향후 `ExternalAiProvider`로 생성형 AI를 교체·보조할 수 있습니다.

## 위험도

`unknown | low | moderate | high | critical`

숫자 하나로만 결정하지 않고 요인 목록·규칙을 함께 보관합니다.

## 외부 연동 경계

| 인터페이스 | 1단계 | 향후 |
|---|---|---|
| ExternalAiProvider | LocalStub | 생성형 AI |
| Location/Weather | Unsupported | 공식 API |
| SensorDataProvider | Sample | PLC/IoT/Modbus |
| NotificationContactProvider | No-op | 승인된 알림 |

API 키는 소스에 넣지 않습니다. Firebase Functions/Firestore 등 유료 가능 서비스는 1단계에서 추가하지 않습니다.
