import 'package:app_project/core/utils/saju_engine.dart';
import 'package:app_project/core/utils/deterministic_random.dart';
import 'package:app_project/features/calendar/models/daily_fortune.dart';
import 'dart:math';

/// 날짜별 운세를 계산하는 서비스
class FortuneCalendarService {
  final Random _random = Random();

  /// 주어진 날짜의 운세를 계산
  DailyFortune calculateDailyFortune({
    required DateTime userBirthDate,
    required DateTime targetDate,
  }) {
    // 사주 기반 계산
    final yearGanJi = SajuEngine.getYearGanJi(userBirthDate);
    final monthGanJi = SajuEngine.getMonthGanJi(userBirthDate);
    final dayGanJi = SajuEngine.getDayGanJi(userBirthDate);

    // 목표 날짜의 일진
    final targetDayGanJi = SajuEngine.getDayGanJi(targetDate);
    final targetDayGan = targetDayGanJi.substring(0, 1);
    final targetDayJi = targetDayGanJi.substring(1, 2);

    // 사용자 일간 추출
    final userDayGan = dayGanJi.substring(0, 1);

    // 오행 계산
    final userOhaeng = SajuEngine.getOhaeng(userDayGan);
    final targetOhaeng = SajuEngine.getOhaeng(targetDayGan);

    // 오행 관계에 따른 기본 점수 계산
    int baseScore = 70;
    final relationship = SajuEngine.getOhaengRelationship(userOhaeng, targetOhaeng);
    
    if (relationship.contains('상생')) {
      baseScore = 85;
    } else if (relationship.contains('같은')) {
      baseScore = 75;
    } else if (relationship.contains('도움')) {
      baseScore = 80;
    }

    // Shinsal 체크 (천을귀인)
    final shinsal = SajuEngine.getShinsal(userDayGan, targetDayJi);
    bool isLuckyDay = shinsal.isNotEmpty;
    if (isLuckyDay) {
      baseScore += 10;
    }

    // 날짜 기반 변동 (deterministic)
    final dayHash = DeterministicRandom.fromDate(targetDate);
    final variation = (dayHash % 21) - 10; // -10 ~ +10
    int totalScore = (baseScore + variation).clamp(0, 100);

    // 세부 점수 계산
    final loveScore = _calculateDetailScore(totalScore, dayHash, 1);
    final moneyScore = _calculateDetailScore(totalScore, dayHash, 2);
    final workScore = _calculateDetailScore(totalScore, dayHash, 3);
    final healthScore = _calculateDetailScore(totalScore, dayHash, 4);

    // 럭키 아이템 계산
    final colors = ['빨간색', '파란색', '노란색', '초록색', '흰색', '검정색', '보라색'];
    final luckyColor = colors[dayHash % colors.length];
    final luckyNumber = (dayHash % 9) + 1;
    final times = ['오전 9~11시', '오전 11시~1시', '오후 1~3시', '오후 3~5시', '오후 5~7시'];
    final luckyTime = times[dayHash % times.length];

    // 요약 메시지 생성
    String summary = relationship;
    if (isLuckyDay) {
      summary += '\\n귀인의 도움을 받을 수 있는 길일이에요!';
    }

    return DailyFortune(
      date: targetDate,
      totalScore: totalScore,
      summary: summary,
      luckyColor: luckyColor,
      luckyNumber: luckyNumber,
      luckyTime: luckyTime,
      isLuckyDay: isLuckyDay,
      loveScore: loveScore,
      moneyScore: moneyScore,
      workScore: workScore,
      healthScore: healthScore,
    );
  }

  /// 세부 점수 계산 (총운 ± 15점 범위)
  int _calculateDetailScore(int totalScore, int dayHash, int category) {
    final variation = ((dayHash * category) % 31) - 15; // -15 ~ +15
    return (totalScore + variation).clamp(0, 100);
  }
}
