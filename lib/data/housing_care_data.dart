import '../models/housing_models.dart';

class HousingCareData {
  HousingCareData._();

  static const checkedAt = '2026-07-29';

  static const heroTitle = '건강할 때의 집과 돌봄이 필요할 때의 집은 다를 수 있습니다.';
  static const heroBody =
      '비싼 실버타운만이 노후주거의 답은 아닙니다. 현재 집에서 안전하게 사는 방법, '
      '지방의 합리적인 노인주거, 공공 고령자주택, 재가돌봄과 장기요양시설까지 '
      '건강과 경제상황에 따라 단계적으로 살펴봅니다.';

  static const disclaimer =
      '이 메뉴는 입력·진단·추천을 하지 않습니다. 대표 상황을 읽고 비교하는 안내이며, '
      '자격·금액·입주 가능 여부는 최신 공고와 전문가 확인이 필요합니다. '
      '특정 민간 시설을 추천하거나 광고하지 않습니다.';

  static const situations = <HousingSituationCard>[
    HousingSituationCard(
      id: 'independent',
      title: '아직 건강하고 독립생활 가능',
      targetSectionId: 'housing-types',
    ),
    HousingSituationCard(
      id: 'housework',
      title: '집안일이 조금씩 어려워짐',
      targetSectionId: 'care-path',
    ),
    HousingSituationCard(
      id: 'outing',
      title: '혼자 외출하거나 병원 가기 어려움',
      targetSectionId: 'care-path',
    ),
    HousingSituationCard(
      id: 'spouse-care',
      title: '배우자의 돌봄이 필요함',
      targetSectionId: 'childfree-scenarios',
    ),
    HousingSituationCard(
      id: 'day-care',
      title: '낮 동안 보호와 활동이 필요함',
      targetSectionId: 'housing-types',
    ),
    HousingSituationCard(
      id: 'hard-home',
      title: '집에서 계속 살기 어려움',
      targetSectionId: 'care-path',
    ),
    HousingSituationCard(
      id: 'dementia',
      title: '치매 돌봄이 필요함',
      targetSectionId: 'care-path',
    ),
    HousingSituationCard(
      id: 'couple-together',
      title: '부부가 함께 지낼 곳을 찾음',
      targetSectionId: 'childfree-scenarios',
    ),
  ];

  static const _mohwHousing = OfficialHousingSource(
    id: 'mohw_housing',
    agency: '보건복지부',
    title: '노인주거복지시설 안내',
    url: 'https://www.mohw.go.kr/menu.es?mid=a10712010500',
    checkedAt: checkedAt,
  );

  static const _ltci = OfficialHousingSource(
    id: 'ltci',
    agency: '국민건강보험공단 노인장기요양보험',
    title: '장기요양보험·기관 안내',
    url: 'https://www.longtermcare.or.kr/',
    checkedAt: checkedAt,
  );

  static const _lhApply = OfficialHousingSource(
    id: 'lh_apply',
    agency: 'LH 청약플러스',
    title: '공공임대·고령자주택 모집공고',
    url: 'https://apply.lh.or.kr/',
    checkedAt: checkedAt,
  );

  static const _lhSenior = OfficialHousingSource(
    id: 'lh_senior_purchase',
    agency: 'LH',
    title: '고령자 매입임대주택 안내',
    url: 'https://www.lh.or.kr/menu.es?mid=a10401030300',
    checkedAt: checkedAt,
  );

  static const _mohwCare = OfficialHousingSource(
    id: 'mohw_custom_care',
    agency: '보건복지부',
    title: '노인맞춤돌봄서비스',
    url: 'https://www.mohw.go.kr/menu.es?mid=a10712030100',
    checkedAt: checkedAt,
  );

  static const _mohwFacility = OfficialHousingSource(
    id: 'mohw_facility',
    agency: '보건복지부',
    title: '노인요양시설·입소 안내',
    url: 'https://www.mohw.go.kr/menu.es?mid=a10712010400',
    checkedAt: checkedAt,
  );

  static const _lst = OfficialHousingSource(
    id: 'lst',
    agency: '국립연명의료관리기관',
    title: '사전연명의료의향·호스피스 관련 안내',
    url: 'https://www.lst.go.kr/',
    checkedAt: checkedAt,
  );

  static const _gov24 = OfficialHousingSource(
    id: 'gov24',
    agency: '정부24',
    title: '공공서비스·신청 안내',
    url: 'https://www.gov.kr',
    checkedAt: checkedAt,
  );

  static const _molitSilverStay = OfficialHousingSource(
    id: 'molit_silver_stay',
    agency: '국토교통부·LH',
    title: '실버스테이 정책·사업 안내(최신 공고 확인)',
    url: 'https://www.lh.or.kr/',
    checkedAt: checkedAt,
    note:
        '2026년 기준 사업 추진·공모·건설 단계인 지역이 있을 수 있습니다. '
        '즉시 입주 가능한 전국 제도처럼 보지 말고 사업별 공고를 확인하세요.',
  );

  static const housingTypes = <SeniorHousingType>[
    SeniorHousingType(
      id: 'aging_in_place',
      slug: 'aging-in-place',
      title: '현재 집에서 계속 살기',
      category: '재가·자립',
      summary: '익숙한 집과 이웃을 유지하며, 집 구조·돌봄·교통을 보완해 독립생활을 이어가는 선택입니다.',
      eligibilityOverview: '법적 입주 자격이 아니라 생활·안전·의료 접근 조건이 핵심입니다.',
      costNature: '주택 유지·수리·난방·돌봄서비스 비용이 주된 부담',
      careLevel: '필요 시 방문요양·맞춤돌봄 등으로 보완',
      medicalLevel: '인근 병원·응급이송에 의존',
      advantages: [
        '익숙한 공간·관계 유지',
        '시설 입주비·월비용 부담이 없을 수 있음',
        '부부·반려동물·개인 생활 리듬을 지키기 쉬움',
      ],
      cautions: [
        '문턱·욕실·계단·화재·고립 위험이 커질 수 있음',
        '배우자 한 사람이 돌봄을 모두 떠맡기 쉬움',
        '운전 중단 후 병원·시장 접근이 급격히 어려워질 수 있음',
      ],
      officialSource: _mohwCare,
      checkedAt: checkedAt,
      variesByNotice: false,
      fitSituations: [
        '기본 일상생활이 가능',
        '병원·시장·교통 접근 가능',
        '집이 너무 크거나 위험하지 않음',
        '배우자·이웃·지역관계가 있음',
      ],
      checkItems: [
        '문턱·욕실 미끄럼·계단·조명·난방',
        '화재안전·비상연락',
        '방문요양·식사지원·병원동행',
        '교통·집수리 비용',
      ],
    ),
    SeniorHousingType(
      id: 'downsize_local',
      slug: 'downsize-local',
      title: '작은 집 또는 지방 생활권으로 이동',
      category: '주거 전환',
      summary: '외딴 농촌 주택에서 읍·중소도시 생활권으로 옮기거나, 관리하기 쉬운 작은 집으로 줄이는 선택입니다.',
      eligibilityOverview: '자가·전세·월세 계약 조건과 지역 생활권이 핵심입니다.',
      costNature: '이전비·중개·리모델링·생활비 구조 변화',
      careLevel: '돌봄은 자동 포함되지 않음',
      medicalLevel: '생활권 내 병원·응급 접근이 핵심',
      advantages: [
        '주택 관리비·난방을 줄일 수 있음',
        '병원·시장·대중교통 접근성 개선 가능',
        '배우자 사별 후 혼자 관리하기 쉬운 크기',
      ],
      cautions: [
        '기존 이웃·텃밭·지역관계 단절 가능',
        '지방이라고 항상 저렴하거나 안전한 것은 아님',
        '의료·교통·가족 거리의 단점도 함께 검토',
      ],
      officialSource: _lhApply,
      checkedAt: checkedAt,
      fitSituations: ['농촌 외딴집 관리가 부담', '운전 중단이 가까움', '혼자 남았을 때 관리 가능한 크기 필요'],
      checkItems: ['병원·시장·대중교통', '자가·전세·월세 장단점', '기존 주택·토지 처리', '새 지역 관계망'],
    ),
    SeniorHousingType(
      id: 'private_silver',
      slug: 'private-silver-town',
      title: '일반 민간 실버타운·노인복지주택',
      category: '민간 노인주거',
      summary:
          '독립생활이 가능한 고령자를 중심으로 주거·식사·생활편의·문화프로그램을 제공하는 민간 시설·주택입니다. '
          '서울 고가 시설만이 대표 사례는 아닙니다.',
      eligibilityOverview: '시설별 연령·건강·계약 조건이 다릅니다. 요양시설과 동일하지 않습니다.',
      costNature: '보증금·월비용·식비·추가서비스 차이가 큼(확인 없는 가격은 표시하지 않음)',
      careLevel: '생활지원 중심. 간호·요양 포함 범위는 계약마다 확인',
      medicalLevel: '의료기관이 아니며, 협력병원·응급이송 조건을 확인',
      advantages: [
        '식사·관리·프로그램으로 일상 부담 감소',
        '같은 세대 이웃과 공동생활',
        '부부 입주가 가능한 곳이 있음',
      ],
      cautions: [
        '건강 악화 후 계속 거주 가능 여부 확인 필요',
        '추가비용·계약해지·보증금 반환 조건이 중요',
        '특정 시설을 근거 없이 추천하지 않음',
      ],
      officialSource: _mohwHousing,
      checkedAt: checkedAt,
      checkItems: [
        '의료·간호·요양 포함 범위',
        '건강 악화 시 거주 가능 여부',
        '부부 입주·추가비용',
        '계약해지·보증금 반환',
      ],
    ),
    SeniorHousingType(
      id: 'affordable_regional_silver',
      slug: 'affordable-regional-silver',
      title: '지방의 합리적인 실버타운',
      category: '민간 노인주거',
      summary:
          '‘알뜰 실버타운’은 법적 시설명칭이 아닐 수 있습니다. 여기서는 수도권 고가 시설보다 '
          '입주비·월 생활비 부담이 낮으면서 병원·교통·식사·안전·공동생활을 어느 정도 갖춘 지방 노후주거를 뜻합니다.',
      eligibilityOverview: '시설·계약별 조건. 지방이라고 무조건 싸거나 좋다고 단정하지 않습니다.',
      costNature: '보증금·월 총비용·식비·관리비·돌봄비 개별 확인',
      careLevel: '시설마다 다름. 요양시설 연계 여부 확인',
      medicalLevel: '의료기관 거리·응급이송이 핵심',
      advantages: [
        '비용 부담이 상대적으로 낮을 수 있음',
        '식사·주거관리·공동생활 가능',
        '부부 입주·개인공간을 비교하며 고를 수 있음',
      ],
      cautions: [
        '의료 접근·교통·가족 거리·시설 선택 폭이 불리할 수 있음',
        '폐업·계약·보증금 보호를 꼼꼼히 확인',
        '자가운전이 어려워질 때를 미리 가정',
      ],
      officialSource: _mohwHousing,
      checkedAt: checkedAt,
      checkItems: [
        '보증금과 월 총비용·식비 포함 여부',
        '간호·돌봄·부부 입주 비용',
        '의료기관 거리·응급이송·대중교통',
        '계약기간·보증금 반환·폐업 대응',
        '건강 악화 후 거주·요양시설 연계',
      ],
    ),
    SeniorHousingType(
      id: 'public_senior_welfare',
      slug: 'public-senior-welfare-housing',
      title: '공공 고령자복지주택',
      category: '공공임대',
      summary:
          '연령·무주택·소득·자산 등 조건을 갖춘 고령자를 위한 공공 주거입니다. '
          '민간 실버타운과 동일한 개념이 아니며, 돌봄이 자동 포함되지 않을 수 있습니다.',
      eligibilityOverview:
          '만 65세 이상 등 연령·무주택·소득·자산 조건은 공고마다 확인. 특정 금액을 단정하지 않습니다.',
      costNature: '공공임대 성격의 임대료·보증금(공고별)',
      careLevel: '복지서비스 연계 가능성은 있으나 실버타운형 풀서비스와 다름',
      medicalLevel: '주거 중심. 의료는 지역 인프라에 의존',
      advantages: [
        '민간 대비 임대 부담이 낮을 수 있음',
        '지역별 모집공고로 투명하게 확인 가능',
        '복지서비스 연계 가능성을 검토할 수 있음',
      ],
      cautions: [
        '원하는 지역 공급·대기 가능성',
        '주택 보유 부부는 자격에서 제한될 수 있음',
        '신청자격은 공고마다 다름',
      ],
      officialSource: _lhApply,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'senior_purchase_rental',
      slug: 'senior-purchase-rental',
      title: '고령자 매입임대주택',
      category: '공공임대',
      summary:
          '저소득 고령자가 현재 생활권 안에서 안정적으로 거주하도록 돕는 LH 매입임대 성격의 주택입니다. '
          '시설형 실버타운이 아니며 돌봄이 자동 포함되지 않습니다.',
      eligibilityOverview: '모집공고 기준 연령·무주택·소득·자산 조건. 지역별 공급 여부 확인.',
      costNature:
          '시세보다 저렴한 임대 가능성이 안내되는 경우가 있음. '
          '2026-07-29 LH 공식 설명에 시세 40% 수준 안내가 있는 부분은 확인하되, '
          '모든 지역·공고에 동일하다고 단정하지 않습니다.',
      careLevel: '돌봄 자동 포함 아님',
      medicalLevel: '주거 중심',
      advantages: [
        '생활권 내 안정적 거주 목적',
        '시세 대비 낮은 임대 가능성(공고·지역별)',
        '시설 입주보다 일반 주택 생활에 가까움',
      ],
      cautions: ['공급 지역·물량이 제한적일 수 있음', '돌봄·식사는 별도 준비', '최신 공고 기준이 우선'],
      officialSource: _lhSenior,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'happy_integrated_rental',
      slug: 'happy-integrated-public-rental',
      title: '행복주택·통합공공임대의 고령자 공급',
      category: '공공임대',
      summary:
          '공공임대 공급 중 고령자 대상이 포함되는 유형입니다. '
          '자격·임대조건·거주기간은 공고문 기준이며, 생활지원·돌봄 포함 여부를 따로 확인합니다.',
      eligibilityOverview: '무주택·소득·자산·연령 등 공고별 기준',
      costNature: '공공임대 조건(공고별)',
      careLevel: '돌봄 자동 포함으로 보지 않음',
      medicalLevel: '주거 중심',
      advantages: ['공공임대 제도 안에서 고령자 공급을 검토 가능', '모집공고로 조건 확인'],
      cautions: [
        '모든 행복주택·통합공공임대가 고령자용이 아님',
        '실제 자격은 최신 공고문 기준',
        '생활지원·돌봄은 별도 확인',
      ],
      officialSource: _lhApply,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'silver_stay',
      slug: 'silver-stay',
      title: '실버스테이',
      category: '정책형 장기임대',
      summary:
          '고령자 맞춤형 시설·서비스를 제공하는 민간 장기임대주택 정책으로, '
          '중산층 고령자 주거 대안 성격이 있습니다. 고가 분양형 실버타운과 다른 장기임대 구조입니다.',
      eligibilityOverview: '사업·공고별. 즉시 입주 가능한 전국 제도처럼 표현하지 않습니다.',
      costNature: '사업별 임대료·조건. 정부 정책이라는 이유만으로 저렴하다고 단정하지 않음',
      careLevel: '사업별 서비스 범위 확인',
      medicalLevel: '사업별 확인',
      advantages: [
        '중산층 고령자 주거 대안으로 검토 가능',
        '분양형과 다른 장기임대 구조',
        '공식 정책·공고로 진행 상황 확인',
      ],
      cautions: [
        '2026년 현재 사업 추진·공모·건설 단계인 곳이 있을 수 있음',
        '입주시기·임대료는 최신 공고 확인',
        '즉시 전국 입주 가능처럼 오해하지 않기',
      ],
      officialSource: _molitSilverStay,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'elderly_living',
      slug: 'elderly-living-facility',
      title: '양로시설·노인공동생활가정',
      category: '노인주거복지',
      summary: '일상생활이 가능한 고령자의 생활지원 중심 시설입니다. 요양시설과 동일하지 않습니다.',
      eligibilityOverview: '무료·실비·유료 등 대상·조건 차이. 보건복지부 공식 입소대상 확인.',
      costNature: '무료·실비·유료에 따라 다름',
      careLevel: '생활지원 중심',
      medicalLevel: '요양·의료기관과 역할이 다름',
      advantages: ['일상생활이 가능한 경우 생활지원을 받을 수 있음', '시설 유형을 요양과 구분해 선택'],
      cautions: ['요양시설과 혼동하지 않기', '건강 악화 시 전환 경로 확인', '입소대상·비용 유형을 공식 안내로 확인'],
      officialSource: _mohwHousing,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'home_ltci',
      slug: 'home-long-term-care',
      title: '재가 장기요양',
      category: '재가돌봄',
      summary:
          '집에서 생활하면서 받는 장기요양 급여입니다. '
          '방문요양·방문목욕·방문간호·주야간보호·단기보호·복지용구 등이 포함됩니다.',
      eligibilityOverview: '장기요양 인정·등급·급여범위는 국민건강보험공단 최신 기준 확인.',
      costNature: '장기요양 본인부담·비급여 항목은 등급·이용에 따라 다름',
      careLevel: '재가급여 중심',
      medicalLevel: '방문간호 등. 요양병원·급성기 병원과 다름',
      advantages: [
        '익숙한 집에서 도움 받기',
        '주야간보호로 낮 동안 보호·활동 가능',
        '배우자 돌봄 부담을 나눌 수 있음',
      ],
      cautions: [
        '등급·인정 절차 필요',
        '야간·응급은 별도 대비',
        '집에서 계속 살기 어려운 신호면 시설급여도 함께 검토',
      ],
      officialSource: _ltci,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'nursing_home',
      slug: 'elderly-care-facility',
      title: '노인요양시설·노인요양공동생활가정',
      category: '시설급여',
      summary:
          '일상생활에 지속적인 도움이 필요한 경우의 장기요양 시설급여입니다. '
          '요양보호·생활지원 중심이며 의료기관과 동일하지 않습니다.',
      eligibilityOverview: '장기요양 인정등급·입소조건. 치매전담형 여부 등 시설별 비교.',
      costNature: '장기요양 본인부담·추가비용(시설별)',
      careLevel: '시설 요양보호·생활지원',
      medicalLevel: '의료기관 아님. 협력병원·응급이송 확인',
      advantages: [
        '지속적 돌봄이 필요할 때 생활 안전 확보',
        '치매전담형 등 특화 서비스 검토 가능',
        '장기요양기관 찾기로 비교 가능',
      ],
      cautions: ['요양병원과 혼동하지 않기', '인력·환경·프로그램·추가비용 비교', '부부 동시 입소·거리·면회 구조 확인'],
      officialSource: _mohwFacility,
      checkedAt: checkedAt,
    ),
    SeniorHousingType(
      id: 'convalescent_hospital',
      slug: 'convalescent-hospital',
      title: '요양병원',
      category: '의료기관',
      summary:
          '치료와 의료적 관리가 필요한 환자를 위한 의료기관입니다. '
          '단순히 나이가 들었다는 이유로 입원하는 주거시설이 아닙니다.',
      eligibilityOverview: '의학적 필요·진료 판단. 주거 목적 입원을 전제로 하지 않음.',
      costNature: '의료비·간병 구조 확인',
      careLevel: '간병·간호는 병원 체계에 따름',
      medicalLevel: '의료진·재활·치료 중심',
      advantages: ['치료·재활·의료 관리가 필요한 경우 적합', '요양원과 역할이 다름을 명확히 구분'],
      cautions: ['주거시설로 오해하지 않기', '비용·간병 구조 확인', '퇴원 이후 생활·주거 계획 필요'],
      officialSource: _ltci,
      checkedAt: checkedAt,
      variesByNotice: false,
    ),
    SeniorHousingType(
      id: 'hospice',
      slug: 'hospice-palliative',
      title: '호스피스·완화의료',
      category: '완화의료',
      summary:
          '말기·임종기의 통증과 불편을 완화하는 의료·돌봄입니다. '
          '일반 실버타운이나 요양시설과 역할이 다릅니다.',
      eligibilityOverview: '공식 의료기관과 상담. 아름다운 마무리 메뉴와 연결.',
      costNature: '의료·제도 안내를 공식 경로에서 확인',
      careLevel: '완화·돌봄',
      medicalLevel: '완화의료',
      advantages: ['통증·불편 완화와 존엄한 마무리에 초점', '가족·배우자 의사결정과 연결'],
      cautions: [
        '실버타운·요양시설과 혼동하지 않기',
        '사전연명의료의향 등 별도 확인',
        '개인 상황에 맞는 의료진 상담 필요',
      ],
      officialSource: _lst,
      checkedAt: checkedAt,
      variesByNotice: false,
    ),
  ];

  static const comparisons = <HousingComparison>[
    HousingComparison(
      typeTitle: '현재 집',
      independence: '높음~중간',
      mainPurpose: '익숙한 생활 유지',
      careIncluded: '별도 신청',
      medicalFunction: '지역 병원 의존',
      costNature: '유지·수리·돌봄비',
      eligibility: '생활 가능 여부',
    ),
    HousingComparison(
      typeTitle: '민간 실버타운',
      independence: '비교적 높음',
      mainPurpose: '주거·식사·편의',
      careIncluded: '계약별(생활지원 중심)',
      medicalFunction: '제한적·협력병원',
      costNature: '보증금·월비용',
      eligibility: '시설별 계약',
    ),
    HousingComparison(
      typeTitle: '지방 실버타운',
      independence: '비교적 높음',
      mainPurpose: '합리적 비용의 노인주거',
      careIncluded: '시설별',
      medicalFunction: '거리·응급이 핵심',
      costNature: '상대적으로 낮을 수 있음',
      eligibility: '시설별 계약',
    ),
    HousingComparison(
      typeTitle: '고령자복지주택',
      independence: '높음',
      mainPurpose: '공공 안정 주거',
      careIncluded: '자동 포함 아님',
      medicalFunction: '지역 인프라',
      costNature: '공공임대',
      eligibility: '공고 자격',
    ),
    HousingComparison(
      typeTitle: '고령자 매입임대',
      independence: '높음',
      mainPurpose: '생활권 내 저렴 임대',
      careIncluded: '없음(별도)',
      medicalFunction: '지역 인프라',
      costNature: '시세 대비 낮을 수 있음',
      eligibility: '공고 자격',
    ),
    HousingComparison(
      typeTitle: '실버스테이',
      independence: '비교적 높음',
      mainPurpose: '장기임대형 고령자 주거',
      careIncluded: '사업별',
      medicalFunction: '사업별',
      costNature: '사업별 임대료',
      eligibility: '사업·공고',
    ),
    HousingComparison(
      typeTitle: '양로시설',
      independence: '중간',
      mainPurpose: '생활지원',
      careIncluded: '생활지원',
      medicalFunction: '요양·의료와 다름',
      costNature: '무료·실비·유료',
      eligibility: '입소대상',
    ),
    HousingComparison(
      typeTitle: '재가 장기요양',
      independence: '중간~낮음',
      mainPurpose: '집에서 돌봄',
      careIncluded: '재가급여',
      medicalFunction: '방문간호 등',
      costNature: '본인부담·비급여',
      eligibility: '장기요양 등급',
    ),
    HousingComparison(
      typeTitle: '노인요양시설',
      independence: '낮음',
      mainPurpose: '시설 요양보호',
      careIncluded: '시설급여',
      medicalFunction: '의료기관 아님',
      costNature: '본인부담·추가비',
      eligibility: '장기요양 등급',
    ),
    HousingComparison(
      typeTitle: '요양병원',
      independence: '낮음',
      mainPurpose: '치료·의료관리',
      careIncluded: '병원 체계',
      medicalFunction: '의료기관',
      costNature: '의료·간병',
      eligibility: '의학적 필요',
    ),
    HousingComparison(
      typeTitle: '호스피스',
      independence: '상황별',
      mainPurpose: '완화·존엄',
      careIncluded: '완화돌봄',
      medicalFunction: '완화의료',
      costNature: '의료·제도',
      eligibility: '의료진 상담',
    ),
  ];

  static const carePath = HousingCarePath(
    stages: [
      CareStage(
        id: 'independent',
        title: '독립생활 가능',
        options: ['현재 집 개선', '작은 집 이동', '실버타운', '공공 고령자주택'],
        keepHomeConditions: [
          '일상생활·안전·병원·교통이 가능',
          '집이 과도하게 크거나 위험하지 않음',
          '비상연락·이웃관계가 있음',
        ],
        transitionSignals: [
          '낙상·화재·고립 위험이 커짐',
          '운전 중단 후 병원 접근이 어려움',
          '배우자 한 사람이 가사·돌봄을 모두 떠맡음',
        ],
        spouseBurden: '아직은 분담 가능하나, 역할·비상연락·재정 공유를 미리 합니다.',
        moneyNotes: '수리·이전·공공임대·민간 계약비를 비교합니다. 확인 없는 가격은 단정하지 않습니다.',
        officialPaths: ['LH 청약플러스', '보건복지부 노인주거복지시설', '노인맞춤돌봄서비스'],
        expertChecks: ['주택 안전', '계약·보증금', '지역 의료 접근'],
      ),
      CareStage(
        id: 'housework_outing',
        title: '집안일·외출이 어려워짐',
        options: ['노인맞춤돌봄', '방문요양', '식사·병원동행', '주야간보호'],
        keepHomeConditions: [
          '낮 동안 도움으로 안전이 유지됨',
          '야간·응급 대응이 가능',
          '배우자·이웃이 완전 고립을 막음',
        ],
        transitionSignals: [
          '밤에도 도움이 반복적으로 필요',
          '외출·병원 동행이 끊김',
          '돌봄자 소진·우울·수면 문제',
        ],
        spouseBurden: '배우자 혼자 감당하지 않도록 공적 서비스·휴식·분담을 검토합니다.',
        moneyNotes: '재가서비스 본인부담·비급여·이동비를 함께 봅니다.',
        officialPaths: ['노인맞춤돌봄서비스', '국민건강보험공단 장기요양'],
        expertChecks: ['장기요양 인정 신청 여부', '주야간보호 적합'],
      ),
      CareStage(
        id: 'continuous_help',
        title: '지속적인 도움이 필요',
        options: ['재가 장기요양 강화', '가족돌봄 분담', '시설급여 검토'],
        keepHomeConditions: [
          '재가급여로 안전·위생·영양이 유지됨',
          '돌봄자가 휴식·교대를 확보',
          '응급·야간 계획이 있음',
        ],
        transitionSignals: [
          '집에서 안전사고·방임 위험이 커짐',
          '두 사람 모두 돌봄이 필요',
          '재가서비스만으로 부족하다는 반복 신호',
        ],
        spouseBurden: '돌봄 소진은 두 사람 건강을 함께 위협합니다. 시설·거리·면회도 함께 봅니다.',
        moneyNotes: '재가 vs 시설 본인부담·추가비용·장기 감당 가능성을 비교합니다.',
        officialPaths: ['장기요양기관 찾기', '보건복지부 노인요양시설 안내'],
        expertChecks: ['등급·급여', '시설 인력·환경', '부부 동시 계획'],
      ),
      CareStage(
        id: 'dementia_severe',
        title: '치매·중증 돌봄 필요',
        options: ['치매전담형 서비스', '노인요양시설', '의료 필요 시 요양병원 검토'],
        keepHomeConditions: [
          '안전·배회·야간 돌봄이 확보됨',
          '돌봄자가 소진되지 않음',
          '의료·응급 연계가 가능',
        ],
        transitionSignals: [
          '야간 배회·폭력·낙상 위험',
          '돌봄자 건강 악화',
          '치료가 주된 필요가 됨(요양병원 검토)',
        ],
        spouseBurden: '배우자 돌봄만으로 버티지 말고 공적 돌봄·시설·의료를 구분합니다.',
        moneyNotes: '치매전담·시설·병원 비용을 혼동하지 않고 각각 확인합니다.',
        officialPaths: ['장기요양기관 찾기', '보건복지부', '의료진 상담'],
        expertChecks: ['요양시설 vs 요양병원', '치매전담형', '면회·거리'],
      ),
      CareStage(
        id: 'end_of_life',
        title: '말기·임종기',
        options: ['의료진 상담', '호스피스·완화의료', '사전연명의료의향 확인'],
        keepHomeConditions: ['통증·불편 완화와 돌봄이 가능', '배우자·신뢰인이 의사결정을 함께함'],
        transitionSignals: ['완화의료·호스피스 상담이 필요한 시점', '연명의료에 대한 본인 의사 확인이 필요'],
        spouseBurden: '남은 배우자의 주거·소득·관계도 함께 준비합니다.',
        moneyNotes: '의료·돌봄 비용과 사후 행정은 공식 안내·전문가로 확인합니다.',
        officialPaths: ['국립연명의료관리기관', '아름다운 마무리 메뉴'],
        expertChecks: ['호스피스 적합성', '사전연명의료의향', '유언·재산'],
      ),
    ],
  );

  static const childfreeScenarios = <ChildfreeCoupleScenario>[
    ChildfreeCoupleScenario(
      id: 'a_rural_home',
      title: '시나리오 A: 건강할 때 농촌 자가주택 유지',
      summary: '낮은 주거비·텃밭·이웃을 지키되, 병원·교통·한 사람 아플 때를 미리 가정합니다.',
      advantages: ['주거비 부담이 낮을 수 있음', '자연·텃밭·이웃관계', '부부 공동 생활 리듬'],
      risks: ['주택수리·난방 부담', '병원·교통·운전 중단', '한 사람이 아플 때 고립'],
      preparations: ['생활권 이동 시점 기준 정하기', '비상연락·이웃·병원 동선', '집 안전·수리·난방 점검'],
      changeSignals: ['운전이 어려워짐', '겨울 난방·수리 감당 어려움', '배우자 건강 악화로 병원 왕복이 잦아짐'],
    ),
    ChildfreeCoupleScenario(
      id: 'b_small_city',
      title: '시나리오 B: 지방 중소도시의 작은 아파트로 이동',
      summary: '병원·시장·교통이 가까운 작은 집으로 옮겨, 혼자 남았을 때도 관리 가능한 구조를 만듭니다.',
      advantages: ['병원·시장·교통', '관리 편의', '혼자 남았을 때 안정성'],
      risks: ['농촌 관계 단절', '이전·정착 비용', '새 이웃 관계 형성 시간'],
      preparations: ['기존 주택·토지 처리 계획', '생활비·관리비 재구성', '새 지역 병원·버스·이웃 확인'],
      changeSignals: [
        '이사 후에도 외로움·고립이 커짐',
        '병원·교통이 생각보다 불편함',
        '관리비·생활비가 예상보다 큼',
      ],
    ),
    ChildfreeCoupleScenario(
      id: 'c_regional_silver',
      title: '시나리오 C: 지방의 합리적인 실버타운 입주',
      summary: '식사·주거관리·프로그램을 받되, 계약·비용·건강 악화 후 연계를 점검합니다.',
      advantages: ['식사·주거관리', '친구·프로그램', '부부 입주 가능성'],
      risks: ['비용·추가비', '계약·보증금·폐업', '기대와 다를 때 퇴거 어려움'],
      preparations: ['총비용·식비·부부비용 확인', '건강 악화 후 거주·연계', '두세 곳 비교·단기 체험'],
      changeSignals: ['추가비용이 계속 늘어남', '개인생활·외출이 과도히 제한됨', '건강 악화로 퇴소 압박'],
    ),
    ChildfreeCoupleScenario(
      id: 'd_public_housing',
      title: '시나리오 D: 공공 고령자주택 신청',
      summary: '자격·지역 공급·대기를 확인하고, 돌봄이 포함되지 않을 수 있음을 전제로 봅니다.',
      advantages: ['임대료 장점 가능성', '공식 모집공고로 확인', '안정적 주거 검토'],
      risks: ['자격 미충족(주택 보유 등)', '원하는 지역 공급·대기', '돌봄 미포함'],
      preparations: ['LH 청약플러스 최신 공고', '무주택·소득·자산 조건 확인', '돌봄은 별도 계획'],
      changeSignals: ['장기간 대기', '돌봄 필요가 주거보다 커짐', '자격 조건 변화'],
    ),
    ChildfreeCoupleScenario(
      id: 'e_mixed_care',
      title: '시나리오 E: 한 사람은 건강하고 배우자는 장기요양이 필요',
      summary: '재가·주야간보호와 시설을 함께 보고, 건강한 배우자의 소진과 만남 거리를 지킵니다.',
      advantages: [
        '집에서 함께 지내며 재가서비스 가능',
        '주야간보호로 낮 부담 완화',
        '시설 입소 시에도 거리·면회 설계 가능',
      ],
      risks: ['배우자 돌봄 소진', '두 사람의 생활비+돌봄비', '시설과 집의 거리'],
      preparations: ['장기요양 인정·등급 확인', '재가 vs 시설 비교', '건강한 배우자의 주거·휴식·관계'],
      changeSignals: ['돌봄자 건강 악화', '야간·응급이 반복', '두 사람 모두 돌봄이 필요해짐'],
    ),
  ];

  static const checklists = <FacilityChecklistSection>[
    FacilityChecklistSection(
      id: 'contract',
      title: '계약',
      items: [
        '설치·신고된 시설 유형',
        '소유·운영 주체',
        '보증금 보호',
        '반환조건',
        '월비용과 추가비용',
        '식비·간병비·관리비',
        '물가상승에 따른 인상기준',
        '중도퇴거',
        '시설 폐업',
        '부부 중 한 사람 사망 시 계약변화',
      ],
    ),
    FacilityChecklistSection(
      id: 'living',
      title: '생활',
      items: [
        '방 크기와 개인공간',
        '식사의 질',
        '외출 자유',
        '프로그램 선택권',
        '종교활동 강요 여부',
        '부부가 함께 살 수 있는지',
        '반려동물',
        '방문객',
        '주변 시장·은행·병원',
        '자가운전 중단 후 교통',
      ],
    ),
    FacilityChecklistSection(
      id: 'health_care',
      title: '건강·돌봄',
      items: [
        '야간인력',
        '간호인력',
        '응급상황 대응',
        '협력병원',
        '병원 이송',
        '치매 발생 시',
        '거동 불편 시',
        '장기요양 등급을 받은 뒤',
        '건강 악화로 퇴소해야 하는 조건',
        '요양시설 연계',
      ],
    ),
    FacilityChecklistSection(
      id: 'visit',
      title: '직접 확인',
      items: [
        '식사를 실제로 먹어보기',
        '입주자에게 생활 만족도 묻기',
        '낮과 저녁 분위기 확인',
        '냄새·청결·소음',
        '직원 교체 빈도',
        '계약서 사전 검토',
        '광고와 실제 서비스 비교',
        '최소 두세 곳 비교',
        '가능하면 단기 체험',
      ],
    ),
  ];

  static const officialSources = <OfficialHousingSource>[
    _mohwHousing,
    _ltci,
    _lhApply,
    _lhSenior,
    _mohwCare,
    _mohwFacility,
    _molitSilverStay,
    _gov24,
    _lst,
    OfficialHousingSource(
      id: 'nps_center',
      agency: '국민연금공단 중앙노후준비지원센터',
      title: '노후준비 안내',
      url: 'https://csa.nps.or.kr',
      checkedAt: checkedAt,
    ),
  ];

  static const distinctionNotes = <String>[
    '민간 실버타운·노인복지주택은 독립생활 중심 주거이며, 노인요양시설(요양원)과 동일하지 않습니다.',
    '공공 고령자복지주택·매입임대는 주거 안정이 목적이며, 돌봄이 자동 포함된다고 보지 않습니다.',
    '실버스테이는 정책형 장기임대이며, 2026년 기준 즉시 전국 입주 가능 제도처럼 표현하지 않습니다.',
    '재가 장기요양은 집에서 받는 급여이고, 시설급여는 요양시설 입소와 연결됩니다.',
    '요양병원은 치료·의료관리가 필요한 의료기관이며, 나이가 들었다는 이유만으로의 주거시설이 아닙니다.',
    '호스피스·완화의료는 말기·임종기 통증 완화이며 실버타운·요양시설과 역할이 다릅니다.',
  ];
}
