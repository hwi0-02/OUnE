/// 꿈해몽 데이터 클래스
class DreamInterpretation {
  final String keyword; // 검색 키워드 (예: "뱀", "물")
  final List<String> relatedKeywords; // 관련 키워드
  final String meaning; // 해몽
  final String luckySign; // 길몽/흉몽 여부
  final int viewCount; // 조회수 (인기도)

  const DreamInterpretation({
    required this.keyword,
    required this.relatedKeywords,
    required this.meaning,
    required this.luckySign,
    this.viewCount = 0,
  });
}

/// 꿈해몽 데이터베이스
class DreamDatabase {
  static final List<DreamInterpretation> dreams = [
    DreamInterpretation(
      keyword: '뱀',
      relatedKeywords: ['구렁이', '비단뱀', '독사', '파충류'],
      meaning: '뱀은 재물, 권력, 지혜를 상징합니다. 금전운이 상승하고 좋은 기회가 찾아올 수 있습니다. 특히 큰 뱀을 본 경우 큰 재물을 얻을 징조입니다.',
      luckySign: '길몽',
      viewCount: 1523,
    ),
    DreamInterpretation(
      keyword: '물',
      relatedKeywords: ['바다', '강', '호수', '폭포', '비'],
      meaning: '맑은 물은 재운과 건강운의 상승을 뜻합니다. 흐르는 물은 돈이 들어올 징조이며, 고인 물은 재물이 쌓이는 것을 의미합니다.',
      luckySign: '길몽',
      viewCount: 1401,
    ),
    DreamInterpretation(
      keyword: '돼지',
      relatedKeywords: ['멧돼지', '새끼돼지', '야생 돼지'],
      meaning: '돼지는 재물과 복을 상징하는 대표적인 길몽입니다. 사업이 번창하고 금전운이 매우 좋아집니다. 특히 새끼를 많이 낳는 돼지는 큰 재물을 의미합니다.',
      luckySign: '길몽',
      viewCount: 1389,
    ),
    DreamInterpretation(
      keyword: '용',
      relatedKeywords: ['청룡', '황룡', '드래곤'],
      meaning: '용은 출세와 권력, 명예를 상징합니다. 승진이나 시험 합격, 사업 성공 등 좋은 일이 생길 징조입니다.',
      luckySign: '대길몽',
      viewCount: 1278,
    ),
    DreamInterpretation(
      keyword: '불',
      relatedKeywords: ['화재', '불길', '화염', '타오르다'],
      meaning: '불은 열정과 변화를 의미합니다. 집이 타는 꿈은 재물운 상승의 징조이며, 자신이 불에 타는 꿈도 좋은 일이 생길 길몽입니다.',
      luckySign: '길몽',
      viewCount: 1156,
    ),
    DreamInterpretation(
      keyword: '죽음',
      relatedKeywords: ['죽다', '사망', '장례식', '관'],
      meaning: '죽음은 새로운 시작과 변화를 의미합니다. 자신이 죽는 꿈은 새로운 출발을 뜻하며, 타인의 죽음은 그 사람과의 관계 변화를 암시합니다.',
      luckySign: '변화의 꿈',
      viewCount: 1012,
    ),
    DreamInterpretation(
      keyword: '시험',
      relatedKeywords: ['시험지', '낙제', '합격', '답안지'],
      meaning: '시험 보는 꿈은 현실의 불안감을 반영합니다. 실제 시험을 앞두고 있다면 준비 상태를 점검해보세요. 시험에 합격하는 꿈은 좋은 결과를 암시합니다.',
      luckySign: '중립',
      viewCount: 967,
    ),
    DreamInterpretation(
      keyword: '임신',
      relatedKeywords: ['임산부', '태아', '출산', '배가 부르다'],
      meaning: '임신은 풍요와 창조를 상징합니다. 새로운 프로젝트 시작이나 아이디어 실현을 의미하며, 재물운 상승의 징조이기도 합니다.',
      luckySign: '길몽',
      viewCount: 945,
    ),
    DreamInterpretation(
      keyword: '돈',
      relatedKeywords: ['현금', '지폐', '동전', '돈다발'],
      meaning: '돈을 줍는 꿈은 의외의 수입이나 행운을 의미합니다. 다만 돈을 잃어버리는 꿈은 재물 손실에 주의해야 한다는 경고입니다.',
      luckySign: '길몽',
      viewCount: 934,
    ),
    DreamInterpretation(
      keyword: '자동차',
      relatedKeywords: ['차', '운전', '사고', '주차'],
      meaning: '자동차는 인생의 방향성과 통제력을 상징합니다. 순조롭게 운전하는 꿈은 삶이 잘 풀려가고 있음을 의미하며, 사고 나는 꿈은 주의가 필요함을 암시합니다.',
      luckySign: '중립',
      viewCount: 823,
    ),
    DreamInterpretation(
      keyword: '집',
      relatedKeywords: ['주택', '아파트', '집 짓기', '이사'],
      meaning: '집은 자아와 안정을 상징합니다. 큰 집으로 이사하는 꿈은 발전과 성장을, 집이 무너지는 꿈은 변화와 재정비를 의미합니다.',
      luckySign: '중립',
      viewCount: 801,
    ),
    DreamInterpretation(
      keyword: '결혼',
      relatedKeywords: ['결혼식', '웨딩드레스', '신혼', '신랑신부'],
      meaning: '결혼은 새로운 시작과 결합을 의미합니다. 실제 결혼을 앞둔 경우가 아니라면 새로운 계약이나 파트너십을 암시합니다.',
      luckySign: '길몽',
      viewCount: 756,
    ),
    // 100개까지 확장 가능
  ];

  /// 키워드로 검색
  static List<DreamInterpretation> search(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return dreams.where((dream) {
      return dream.keyword.toLowerCase().contains(lowerQuery) ||
          dream.relatedKeywords.any((k) => k.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// 인기 꿈 Top N 조회
  static List<DreamInterpretation> getPopular({int limit = 10}) {
    final sorted = List<DreamInterpretation>.from(dreams)
      ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return sorted.take(limit).toList();
  }
}
