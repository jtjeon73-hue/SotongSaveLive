# 콘텐츠 아키텍처 (2단계)

- `LifeTypeProfile`: slug·categories·tags·relatedLinks로 확장 가능
- `LifeScenarioRepository`: slug 조회, 이전/다음 순환, 관련 추천
- `MindEssay` / `MindEssayRepository`: 마음쉼터 읽을거리
- 라우트: `/life-paths`, `/life-paths/:type`, `/mind-lounge`, `/mind-lounge/:slug`
- 레거시 `/five-lives` 는 `/life-paths`로 리다이렉트

고전·철학 콘텐츠는 현대 번역 복제 없이 사상 해설만 제공하며, 특정 종교를 유일한 정답으로 단정하지 않습니다.
