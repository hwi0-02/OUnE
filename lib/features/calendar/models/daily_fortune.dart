/// 일일 운세 데이터 모델
class DailyFortune {
  final DateTime date;
  final int totalScore;
  final String summary;
  final String luckyColor;
  final int luckyNumber;
  final String luckyTime;
  final bool isLuckyDay; // 길일 여부
  
  // 세부 점수
  final int loveScore;
  final int moneyScore;
  final int workScore;
  final int healthScore;

  const DailyFortune({
    required this.date,
    required this.totalScore,
    required this.summary,
    required this.luckyColor,
    required this.luckyNumber,
    required this.luckyTime,
    required this.isLuckyDay,
    required this.loveScore,
    required this.moneyScore,
    required this.workScore,
    required this.healthScore,
  });

  /// 점수를 별점으로 변환 (0~100 → 1~5)
  int get stars => ((totalScore / 20).ceil()).clamp(1, 5);

  /// 길일/흉일 판단 기준
  String get dayType {
    if (isLuckyDay && totalScore >= 80) return '대길일';
    if (isLuckyDay) return '길일';
    if (totalScore < 50) return '흉일';
    return '보통';
  }
}
