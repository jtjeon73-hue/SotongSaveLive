import '../models/life_models.dart';

class OfficialSourceRepository {
  static const checkedOn = '2026-07-29';

  static const sources = <OfficialSource>[
    OfficialSource(
      id: 'nps_center',
      agency: '국민연금공단 중앙노후준비지원센터',
      title: '노후준비 4대 영역(재무·건강·여가·대인관계) 안내',
      url: 'https://csa.nps.or.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'nps',
      agency: '국민연금공단',
      title: '국민연금 제도 안내',
      url: 'https://www.nps.or.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'fss_pension',
      agency: '금융감독원 통합연금포털',
      title: '연금 조회·비교 안내',
      url: 'https://www.fss.or.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'ltci',
      agency: '국민건강보험공단 노인장기요양보험',
      title: '장기요양보험 제도 안내',
      url: 'https://www.longtermcare.or.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'mohw',
      agency: '보건복지부',
      title: '노인·돌봄·복지 정책 안내',
      url: 'https://www.mohw.go.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'lst',
      agency: '국립연명의료관리기관',
      title: '사전연명의료의향서 안내',
      url: 'https://www.lst.go.kr',
      checkedOn: checkedOn,
      needsExpertReview: false,
    ),
    OfficialSource(
      id: 'nts',
      agency: '국세청',
      title: '세금·연금소득 관련 안내',
      url: 'https://www.nts.go.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'moel',
      agency: '고용노동부',
      title: '퇴직연금·고용·재취업 관련 안내',
      url: 'https://www.moel.go.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'gov24',
      agency: '정부24',
      title: '공공서비스·증명·신청 안내',
      url: 'https://www.gov.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'greendaero',
      agency: '귀농귀촌 종합센터(그린대로)',
      title: '귀농·귀촌 정보',
      url: 'https://www.returnfarm.com',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'mafra',
      agency: '농림축산식품부',
      title: '농업·농촌 정책 안내',
      url: 'https://www.mafra.go.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'rda',
      agency: '농촌진흥청',
      title: '농업기술·농촌생활 정보',
      url: 'https://www.rda.go.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'kostat',
      agency: '통계청',
      title: '인구·가구·고령 통계',
      url: 'https://kostat.go.kr',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'lh_apply',
      agency: 'LH 청약플러스',
      title: '공공임대·고령자주택 모집공고',
      url: 'https://apply.lh.or.kr/',
      checkedOn: checkedOn,
      note: '모집 중인 공고를 상시 이용 가능한 제도로 오해하지 마세요.',
    ),
    OfficialSource(
      id: 'lh_senior',
      agency: 'LH',
      title: '고령자 매입임대주택 안내',
      url: 'https://www.lh.or.kr/menu.es?mid=a10401030300',
      checkedOn: checkedOn,
    ),
    OfficialSource(
      id: 'mohw_housing',
      agency: '보건복지부',
      title: '노인주거복지시설 안내',
      url: 'https://www.mohw.go.kr/menu.es?mid=a10712010500',
      checkedOn: checkedOn,
    ),
  ];

  static OfficialSource? byId(String id) {
    for (final s in sources) {
      if (s.id == id) return s;
    }
    return null;
  }
}
