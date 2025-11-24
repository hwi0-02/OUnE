/// 재미 콘텐츠 데이터베이스
class FunContentDatabase {
  // 포춘쿠키 메시지
  static const List<String> fortuneCookies = [
    '오늘 당신에게 특별한 행운이 찾아올 거예요! ✨',
    '당신의 노력이 곧 빛을 발할 것입니다 💫',
    '진심은 언제나 통하는 법이에요 ♡',
    '오늘은 용기를 내보는 날로 하세요! 💪',
    '당신은 생각보다 훨씬 강한 사람이에요 🌟',
    '행복은 작은 것에서 시작됩니다 🌈',
    '오늘 만나는 사람이 당신의 귀인이 될 수 있어요 🎁',
    '긍정적인 마음가짐이 행운을 부릅니다 ☀️',
    '당신의 미소가 누군가에게 위로가 될 거예요 😊',
    '오늘 하루도 화이팅! 당신은 할 수 있어요 🚀',
    '좋은 일은 예고 없이 찾아온답니다 🎉',
    '당신의 꿈은 이루어질 거예요 🌠',
    '오늘은 특별한 기회가 찾아올 날이에요 🍀',
    '당신의 선택은 언제나 옳았어요 ✅',
    '행운의 에너지가 당신을 감싸고 있어요 🌸',
  ];

  // 오늘의 명언
  static const List<String> dailyQuotes = [
    '인생은 자전거를 타는 것과 같다. 균형을 유지하려면 계속 움직여야 한다. - 알버트 아인슈타인',
    '당신이 할 수 있다고 믿든 할 수 없다고 믿든, 당신이 옳다. - 헨리 포드',
    '성공은 최종적인 것이 아니며, 실패는 치명적인 것이 아니다. 중요한 것은 계속하려는 용기다. - 윈스턴 처칠',
    '미래는 자신의 꿈의 아름다움을 믿는 사람들의 것이다. - 엘리너 루즈벨트',
    '행복의 비밀은 자유이고, 자유의 비밀은 용기다. - 페리클레스',
    '당신이 할 수 있는 가장 위대한 일은 당신 스스로가 되는 것이다. - 오스카 와일드',
    '오늘 할 수 있는 일을 내일로 미루지 마라. - 벤자민 프랭클린',
    '성공의 열쇠는 실패를 두려워하지 않는 것이다. - 마이클 조던',
    '삶이 있는 한 희망은 있다. - 키케로',
    '당신의 시간은 제한되어 있다. 다른 사람의 삶을 사느라 낭비하지 마라. - 스티브 잡스',
  ];

  // 액막이 기원 문구
  static const List<String> blessings = [
    '오늘 하루 나쁜 기운은 모두 사라지고, 좋은 기운만 가득하길 🙏',
    '오운이가 당신을 지켜줄게요! 오늘도 무사히 ✨',
    '부정적인 에너지는 모두 사라지고, 긍정의 기운이 가득하길 💫',
    '오늘 하루 액운은 멀리하고, 복운만 가까이 🌟',
    '나쁜 일은 멀리 가고, 좋은 일만 가득하길 바래요 ♡',
    '모든 어려움은 지나가고, 행복만 남을 거예요 🌈',
    '오늘 하루 평안하고 건강하게 보내세요 🍀',
    '당신을 향한 모든 부정적인 기운을 막아드려요 🛡️',
  ];

  /// 날짜 기반 포춘쿠키 조회 (매일 다른 메시지)
  static String getTodayFortuneCookie() {
    final now = DateTime.now();
    final index = (now.year * 1000 + now.month * 100 + now.day) % fortuneCookies.length;
    return fortuneCookies[index];
  }

  /// 날짜 기반 명언 조회
  static String getTodayQuote() {
    final now = DateTime.now();
    final index = (now.year * 1000 + now.month * 100 + now.day) % dailyQuotes.length;
    return dailyQuotes[index];
  }

  /// 날짜 기반 액막이 문구 조회
  static String getTodayBlessing() {
    final now = DateTime.now();
    final index = (now.year * 1000 + now.month * 100 + now.day) % blessings.length;
    return blessings[index];
  }
}
