import 'dart:math';
import 'package:app_project/core/utils/deterministic_random.dart';
import 'package:app_project/data/models/fortune_model.dart';
import 'package:app_project/data/models/user_model.dart';
import 'package:app_project/core/utils/saju_engine.dart';

class FortuneService {
  /// Calculates daily fortune based on user's Saju and today's Iljin.
  FortuneModel getDailyFortune(UserModel user, DateTime date) {
    // 1. Calculate User's Day Pillar (Il-ju) - The core of self
    // Note: Ideally we need birth time for precise Saju, but for MVP we use Day Pillar.
    final String userDayGanJi = SajuEngine.getDayGanJi(user.birthDate);
    final String userDayGan = userDayGanJi.substring(0, 1); // Day Master (Il-gan)
    final String userOhaeng = SajuEngine.getOhaeng(userDayGan);

    // 2. Calculate Today's Pillars
    final String todayYearGanJi = SajuEngine.getYearGanJi(date);
    final String todayMonthGanJi = SajuEngine.getMonthGanJi(date);
    final String todayDayGanJi = SajuEngine.getDayGanJi(date);
    
    final String todayDayGan = todayDayGanJi.substring(0, 1);
    final String todayDayJi = todayDayGanJi.substring(1, 2);
    final String todayOhaeng = SajuEngine.getOhaeng(todayDayGan);

    // 3. Generate deterministic score based on Saju interaction
    // Use DeterministicRandom for consistency
    final String seed = DeterministicRandom.createSeed(user.id, date);
    final Random random = DeterministicRandom.fromSeed(seed);

    int baseScore = 50 + random.nextInt(41); // 50 ~ 90
    
    // Bonus score based on Ohaeng relationship (Simplified)
    // If Ohaengs are compatible (Sangsaeng), add bonus.
    if (SajuEngine.getOhaengRelationship(userOhaeng, todayOhaeng).contains("상생") ||
        SajuEngine.getOhaengRelationship(userOhaeng, todayOhaeng).contains("도움")) {
      baseScore += 10;
    }
    
    // Shinsal Bonus (Nobleman)
    final String shinsal = SajuEngine.getShinsal(userDayGan, todayDayJi);
    if (shinsal.isNotEmpty) {
      baseScore += 15; // Big bonus for Nobleman
    }
    
    // Cap at 100
    final int score = min(100, baseScore);

    // 4. Determine Lucky Items
    final colors = ['빨강', '주황', '노랑', '초록', '파랑', '남색', '보라', '분홍', '흰색', '검정', '금색', '은색'];
    final luckyColor = colors[random.nextInt(colors.length)];
    final luckyNumber = 1 + random.nextInt(99);

    // 5. Generate Content
    String contentHeader = "오늘의 일진: $todayYearGanJi년 $todayMonthGanJi월 $todayDayGanJi일";
    String ohaengAnalysis = "당신($userDayGan/$userOhaeng)과 오늘($todayDayGan/$todayOhaeng)은 ${SajuEngine.getOhaengRelationship(userOhaeng, todayOhaeng)}입니다.";
    
    if (shinsal.isNotEmpty) {
      ohaengAnalysis += "\\n\\n✨ 특별한 기운: $shinsal이 들어와 귀인의 도움을 받을 수 있습니다!";
    }
    
    String advice;
    if (score >= 90) {
      advice = "기운이 하늘을 찌르는 날! 망설이지 말고 도전하세요.";
    } else if (score >= 75) {
      advice = "흐름이 아주 좋습니다. 순풍에 돛을 단 듯 하네요.";
    } else if (score >= 60) {
      advice = "평온하고 무난한 하루입니다. 일상을 즐기세요.";
    } else {
      advice = "조금은 신중함이 필요한 날입니다. 돌다리도 두들겨 보고 건너세요.";
    }

    final String fullContent = "$contentHeader\\n\\n$ohaengAnalysis\\n\\n$advice";

    return FortuneModel(
      id: 'local_${date.millisecondsSinceEpoch}',
      userId: user.id,
      date: date,
      totalScore: score,
      content: fullContent,
      luckyColor: luckyColor,
      luckyNumber: luckyNumber,
    );
  }

  /// Calculates detailed fortune for 4 categories
  Map<String, Map<String, dynamic>> getDetailedFortune(UserModel user, DateTime date) {
    final String userDayGanJi = SajuEngine.getDayGanJi(user.birthDate);
    final String userDayGan = userDayGanJi.substring(0, 1);
    final String userOhaeng = SajuEngine.getOhaeng(userDayGan);
    
    final String todayDayGanJi = SajuEngine.getDayGanJi(date);
    final String todayDayGan = todayDayGanJi.substring(0, 1);
    final String todayDayJi = todayDayGanJi.substring(1, 2);
    final String todayOhaeng = SajuEngine.getOhaeng(todayDayGan);

    // Generate deterministic random seed
    final String seed = DeterministicRandom.createSeed(user.id, date, suffix: 'detailed');
    final Random random = DeterministicRandom.fromSeed(seed);

    // Base relationship bonus
    final bool isCompatible = SajuEngine.getOhaengRelationship(userOhaeng, todayOhaeng).contains("상생") ||
        SajuEngine.getOhaengRelationship(userOhaeng, todayOhaeng).contains("도움");
    final int baseBonus = isCompatible ? 10 : 0;

    // Love Fortune (연애운)
    int loveScore = 50 + random.nextInt(40) + baseBonus;
    String loveContent;
    if (loveScore >= 85) {
      loveContent = "오늘은 사랑의 에너지가 폭발하는 날이에요! 마음이 가는 사람에게 용기 내어 다가가보세요. 좋은 결과가 있을 거예요 💕";
    } else if (loveScore >= 70) {
      loveContent = "연애운이 좋은 편이에요. 데이트 약속을 잡거나, 가벼운 대화로 마음을 나눠보는 건 어떨까요?";
    } else if (loveScore >= 50) {
      loveContent = "평온한 날이에요. 무리하게 관계를 진전시키기보다는 현재를 즐기는 게 좋아요.";
    } else {
      loveContent = "조금은 신중함이 필요한 날이에요. 감정적으로 행동하기보다는 한 발 물러서서 생각해보세요.";
    }
    loveScore = min(100, loveScore);

    // Money Fortune (재물운)
    int moneyScore = 50 + random.nextInt(40) + baseBonus;
    String moneyContent;
    if (moneyScore >= 85) {
      moneyContent = "재물운이 상승세예요! 투자나 부업 기회가 있다면 신중하게 검토해보세요. 의외의 수입이 생길 수 있어요 💰";
    } else if (moneyScore >= 70) {
      moneyContent = "금전적으로 안정된 하루예요. 계획했던 소비는 괜찮지만, 충동구매는 자제하는 게 좋겠어요.";
    } else if (moneyScore >= 50) {
      moneyContent = "평범한 재물운이에요. 큰 지출은 피하고 저축에 신경 쓰면 좋을 것 같아요.";
    } else {
      moneyContent = "오늘은 지갑을 꼭 잡고 있어야 할 날이에요. 불필요한 소비는 과감히 줄이세요.";
    }
    moneyScore = min(100, moneyScore);

    // Work Fortune (직장운)
    int workScore = 50 + random.nextInt(40) + baseBonus;
    String workContent;
    if (workScore >= 85) {
      workContent = "업무 효율이 최고조예요! 중요한 프로젝트나 발표가 있다면 오늘이 최적의 날이에요. 자신감을 가지세요 💼";
    } else if (workScore >= 70) {
      workContent = "일이 순조롭게 풀리는 날이에요. 동료들과의 협업도 잘 될 거예요.";
    } else if (workScore >= 50) {
      workContent = "무난한 하루예요. 급하게 서두르지 말고 차근차근 진행하세요.";
    } else {
      workContent = "조금 힘들 수 있는 하루예요. 실수하지 않도록 꼼꼼히 확인하는 습관을 들이세요.";
    }
    workScore = min(100, workScore);

    // Health Fortune (건강운)
    int healthScore = 50 + random.nextInt(40) + baseBonus;
    String healthContent;
    if (healthScore >= 85) {
      healthContent = "컨디션이 최상이에요! 운동이나 등산 같은 활동적인 일정을 잡아도 좋아요 💪";
    } else if (healthScore >= 70) {
      healthContent = "건강 상태가 양호해요. 가벼운 스트레칭이나 산책으로 몸을 풀어주세요.";
    } else if (healthScore >= 50) {
      healthContent = "피로가 쌓일 수 있어요. 충분한 휴식과 수분 섭취를 챙기세요.";
    } else {
      healthContent = "무리하지 마세요. 오늘은 몸이 보내는 신호에 귀 기울이고 푹 쉬는 게 중요해요.";
    }
    healthScore = min(100, healthScore);

    return {
      'love': {'score': loveScore, 'content': loveContent},
      'money': {'score': moneyScore, 'content': moneyContent},
      'work': {'score': workScore, 'content': workContent},
      'health': {'score': healthScore, 'content': healthContent},
    };
  }
}
