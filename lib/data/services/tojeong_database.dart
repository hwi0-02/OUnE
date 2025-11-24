/// 토정비결 괘 데이터
class TojeongHexagram {
  final int number; // 1~64
  final String title; // 괘 제목
  final String fortune; // 전반적인 운세
  final String warning; // 주의사항
  final String advice; // 조언

  const TojeongHexagram({
    required this.number,
    required this.title,
    required this.fortune,
    required this.warning,
    required this.advice,
  });
}

/// 토정비결 64괘 데이터베이스
class TojeongDatabase {
  static const List<TojeongHexagram> hexagrams = [
    TojeongHexagram(
      number: 1,
      title: '상상괘(上上卦) - 용천비룡',
      fortune: '용이 하늘로 날아오르는 형상이니, 모든 일이 순조롭고 귀인의 도움을 받게 됩니다. 재물운이 왕성하고 명예와 지위가 상승하는 대길한 해입니다.',
      warning: '지나친 자만심과 교만을 조심하세요. 겸손을 잃으면 모든 것을 잃을 수 있습니다.',
      advice: '매사에 신중하게 처신하고, 주변 사람들에게 감사의 마음을 잊지 마세요.',
    ),
    TojeongHexagram(
      number: 2,
      title: '상길괘(上吉卦) - 봄날의 꽃',
      fortune: '꽃이 만발하는 봄처럼 새로운 시작과 발전이 있는 해입니다. 노력한 만큼 결실을 보게 되며, 인간관계가 원만합니다.',
      warning: '서두르지 말고 차근차근 진행하세요. 무리한 욕심은 실패를 초래할 수 있습니다.',
      advice: '기회를 놓치지 말고, 새로운 도전을 두려워하지 마세요.',
    ),
    TojeongHexagram(
      number: 3,
      title: '중길괘(中吉卦) - 구름 속의 달',
      fortune: '때때로 어려움이 있지만 결국엔 좋은 결과를 얻게 됩니다. 인내심을 가지고 기다리면 행운이 찾아옵니다.',
      warning: '조급한 마음을 버리고 때를 기다리는 지혜가 필요합니다.',
      advice: '어려움 속에서도 긍정적인 마음가짐을 유지하세요.',
    ),
    TojeongHexagram(
      number: 4,
      title: '평괘(平卦) - 잔잔한 호수',
      fortune: '큰 변화 없이 평온한 한 해가 될 것입니다. 안정적이지만 발전을 위해서는 노력이 필요합니다.',
      warning: '현상 유지에 안주하지 말고 작은 노력이라도 꾸준히 하세요.',
      advice: '작은 일에서부터 차근차근 준비하면 나중에 큰 성과를 거둘 수 있습니다.',
    ),
    TojeongHexagram(
      number: 5,
      title: '하괘(下卦) - 시련의 겨울',
      fortune: '어려움과 시련이 많은 해이지만, 이를 극복하면 더 강해질 수 있습니다. 인내와 지혜가 필요한 시기입니다.',
      warning: '감정적인 판단을 하지 말고 냉정하게 상황을 파악하세요.',
      advice: '어려울수록 초심을 잃지 말고 기본에 충실하세요.',
    ),
    // 간략화를 위해 5개만 샘플로 작성, 실제로는 64개 필요
    TojeongHexagram(
      number: 6,
      title: '중상괘(中上卦) - 아침의 해',
      fortune: '새벽을 지나 아침 해가 떠오르는 형상입니다. 점차 상황이 좋아지며, 하반기로 갈수록 운이 상승합니다.',
      warning: '처음부터 큰 성공을 기대하지 말고, 차근차근 단계를 밟아가세요.',
      advice: '꾸준한 노력이 결국 성공으로 이어집니다.',
    ),
    TojeongHexagram(
      number: 7,
      title: '상중괘(上中卦) - 가을의 수확',
      fortune: '노력한 만큼 결실을 거두는 해입니다. 재물운과 건강운이 좋으며, 인간관계도 원만합니다.',
      warning: '수확한 것에 만족하지 말고 다음을 준비하세요.',
      advice: '감사하는 마음으로 나눔을 실천하면 더 큰 복이 옵니다.',
    ),
    TojeongHexagram(
      number: 8,
      title: '길괘(吉卦) - 만물 생동',
      fortune: '만물이 생동하는 봄처럼 활기찬 한 해입니다. 새로운 계획과 도전에 좋은 시기입니다.',
      warning: '너무 많은 일을 벌이면 산만해질 수 있으니 우선순위를 정하세요.',
      advice: '건강관리에 신경 쓰면서 활동적으로 움직이세요.',
    ),
    // 실제 앱에서는 64개 전체를 작성해야 합니다
    // 나머지는 유사한 패턴으로 작성
  ];

  /// 괘 번호로 토정비결 조회
  static TojeongHexagram getHexagram(int number) {
    if (number < 1 || number > hexagrams.length) {
      // 범위 밖인 경우 기본 괘 반환
      return hexagrams[3]; // 평괘
    }
    return hexagrams[number - 1];
  }

  /// 생년월일 기반 괘 번호 계산 (간략화된 로직)
  static int calculateHexagramNumber({
    required DateTime birthDate,
    required int targetYear,
  }) {
    // 토정비결 전통 계산법 (간략화)
    // 실제로는 더 복잡한 계산이 필요하지만, 여기서는 deterministic한 방식으로 구현
    final yearDigit = birthDate.year % 10;
    final monthDigit = birthDate.month;
    final dayDigit = birthDate.day % 10;
    final targetYearDigit = targetYear % 10;

    // 조합하여 1~64 범위의 숫자 생성
    final hash = (yearDigit * 1000 + monthDigit * 100 + dayDigit * 10 + targetYearDigit) % 64;
    return hash + 1; // 1~64
  }
}
