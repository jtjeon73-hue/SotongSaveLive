# SotongSaveLive

AI 인생·노후설계 플랫폼 — 질문 없이, 다양한 **노후맞이 인생**과 **마음쉼터**, **노후 주거·돌봄** 읽을거리를 보며 남은 삶을 설계합니다.

> 오래 사는 것보다 중요한 것은  
> 남은 시간을 나답게 살아가는 것입니다.

## 운영 배포 (Firebase Hosting)

| 항목 | 값 |
| --- | --- |
| Firebase 프로젝트 ID | `sotong-save-live` |
| 운영주소 | https://sotong-save-live.web.app |
| 보조 운영주소 | https://sotong-save-live.firebaseapp.com |
| 요금제 | Spark (무료) — Hosting만 사용 |
| 앱 버전 | `1.2.0+3` |

### 수동 빌드

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
flutter build web --release
```

### Hosting 배포

```bash
firebase deploy --only hosting --project sotong-save-live
```

- Spark 무료 Hosting만 사용합니다.
- Firestore, Functions, Storage, Authentication 등 유료·백엔드 서비스는 사용하지 않습니다.
- 외부 생성형 AI API는 연결하지 않습니다.

## 왜 ‘다섯 가지’가 아닌가

삶은 한 기준으로 나눌 수 없습니다. 1단계의 대표 유형을 유지하면서 **노후맞이 인생들**로 확장했고, 데이터 기반으로 유형을 계속 추가할 수 있습니다.

## 9개 메뉴

1. 홈  
2. 노후맞이 인생들  
3. AI 인생로드맵  
4. 돈과 평생일  
5. 건강·관계·생활  
6. 농촌과 제2의 인생  
7. 노후 주거·돌봄  
8. 마음쉼터  
9. 아름다운 마무리  

## 노후맞이 인생 (현재 13+)

직장 은퇴, 이미 은퇴, 프리랜서, 사업, 농촌, 공무원·교직, 전업주부·돌봄, 1인 가구, 부부 노후, **자녀 없이 부부가 함께 살아가는 노후**, 재취업·제2직업, 전문기술·창작, 경제적 재설계 등.

유형 추가: `lib/data/life_types_*.dart`에 프로필을 만들고 `LifeTypesData.all`에 넣으면 됩니다. slug·categories·tags·relatedLinks를 함께 둡니다.

## 마음쉼터

종교 강요가 아닌 지혜 읽기 공간입니다. 고전·철학은 **현대 출판 번역을 복제하지 않고** 사상을 자체 문장으로 해설합니다.

## 로컬 실행·테스트

```bash
flutter pub get
flutter run -d chrome
flutter test
flutter build web --release
```

## 원칙

- 사용자 입력·로그인·개인정보 저장 없음  
- 외부 생성형 AI API·유료 백엔드 미사용  
- 제도·금액은 공식 출처·확인일 기준, 예시 금액은 가상 대표 사례  
