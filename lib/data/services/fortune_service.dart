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
      loveContent = "💕 오늘은 사랑의 에너지가 폭발하는 날이에요!\n\n"
          "당신의 일간($userDayGan)과 오늘의 기운($todayDayGan)이 만나 사랑의 오행이 활성화되었습니다. "
          "마음이 가는 사람에게 용기 내어 다가가보세요. 고백이나 프로포즈를 계획하고 있다면 오늘이 최적의 날입니다. "
          "특히 오후 시간대에 분위기 좋은 장소에서 만나면 좋은 결과가 있을 거예요.\n\n"
          "💡 연애 팁: 상대방의 이야기에 귀 기울이고 공감해주세요. 당신의 진심이 전해지는 하루입니다. "
          "저녁에는 조용한 레스토랑이나 야경이 보이는 곳에서 데이트를 즐겨보세요. "
          "솔로라면 소개팅이나 새로운 만남의 자리에 적극적으로 나서보는 것을 추천합니다!";
    } else if (loveScore >= 70) {
      loveContent = "💗 연애운이 좋은 편이에요!\n\n"
          "오늘의 오행 기운이 당신의 사주와 조화를 이루고 있습니다. "
          "데이트 약속을 잡거나, 가벼운 대화로 마음을 나눠보는 건 어떨까요? "
          "연인이 있다면 함께 산책하거나 카페에서 여유로운 시간을 보내면 관계가 더욱 돈독해질 것입니다.\n\n"
          "💡 연애 팁: 작은 선물이나 손편지를 준비하면 상대방의 마음을 움직일 수 있어요. "
          "과거의 추억을 떠올리며 이야기를 나누는 것도 좋습니다. "
          "솔로라면 친구들과의 모임에서 좋은 인연을 만날 수 있으니 적극적으로 참여해보세요.";
    } else if (loveScore >= 50) {
      loveContent = "💙 평온한 연애운이에요.\n\n"
          "오늘은 급격한 변화보다는 현재 상태를 유지하는 것이 좋은 날입니다. "
          "무리하게 관계를 진전시키기보다는 현재를 즐기는 게 좋아요. "
          "연인이 있다면 집에서 함께 영화를 보거나 편안한 시간을 보내는 것을 추천합니다.\n\n"
          "💡 연애 팁: 상대방에게 부담을 주는 요구나 무리한 제안은 피하세요. "
          "대신 일상적인 대화와 소소한 관심 표현으로 마음을 전하는 것이 효과적입니다. "
          "솔로라면 너무 조급하게 생각하지 말고, 자기계발에 집중하면서 자연스러운 만남을 기다려보세요.";
    } else {
      loveContent = "💜 조금은 신중함이 필요한 날이에요.\n\n"
          "오늘의 오행이 당신의 사주와 약간의 충돌을 일으킬 수 있습니다. "
          "감정적으로 행동하기보다는 한 발 물러서서 생각해보세요. "
          "중요한 결정이나 민감한 주제의 대화는 며칠 미루는 것이 좋습니다.\n\n"
          "💡 연애 팁: 상대방의 말과 행동을 오해하지 않도록 차분히 대화하세요. "
          "작은 일로 다툼이 생길 수 있으니 참을성을 가지고 이해하려는 자세가 필요합니다. "
          "오늘은 연락을 조금 줄이고 각자의 시간을 가지는 것도 관계를 위해 좋을 수 있어요. "
          "솔로라면 새로운 만남보다는 자기 성찰의 시간을 가져보세요.";
    }
    loveScore = min(100, loveScore);

    // Money Fortune (재물운)
    int moneyScore = 50 + random.nextInt(40) + baseBonus;
    String moneyContent;
    if (moneyScore >= 85) {
      moneyContent = "💰 재물운이 최고조에 달했어요!\n\n"
          "당신의 재성운이 활발하게 움직이고 있습니다. 투자나 부업 기회가 있다면 신중하게 검토해보세요. "
          "특히 오전 시간대에 들어온 제안이나 정보는 귀담아들을 가치가 있습니다. "
          "의외의 수입이 생기거나, 오래전 빌려준 돈을 돌려받을 수도 있어요.\n\n"
          "💡 재물 팁: 주식이나 코인 투자를 고려 중이라면 전문가의 조언을 구한 후 결정하세요. "
          "부동산 계약이나 큰 거래도 유리하게 진행될 가능성이 높습니다. "
          "단, 욕심을 부리지 말고 적정선에서 만족하는 지혜가 필요해요. "
          "로또나 복권을 구매해보는 것도 재미있을 것 같네요!";
    } else if (moneyScore >= 70) {
      moneyContent = "💵 금전적으로 안정된 하루예요.\n\n"
          "오늘의 재물 기운이 당신을 안정적으로 보호하고 있습니다. "
          "계획했던 소비는 괜찮지만, 충동구매는 자제하는 게 좋겠어요. "
          "필요한 물건이 있다면 할인 정보를 찾아보거나 중고거래를 활용하면 합리적인 소비를 할 수 있습니다.\n\n"
          "💡 재물 팁: 가계부를 정리하거나 재정 계획을 세우기 좋은 날입니다. "
          "정기적금이나 적금 가입을 고민하고 있다면 오늘 알아보세요. "
          "친구나 가족에게 작은 선물을 하면 나중에 더 큰 복으로 돌아올 수 있어요. "
          "단, 대출이나 보증은 신중하게 결정하세요.";
    } else if (moneyScore >= 50) {
      moneyContent = "💳 평범한 재물운이에요.\n\n"
          "오늘은 큰 변화 없이 평온한 재정 상태가 유지됩니다. "
          "큰 지출은 피하고 저축에 신경 쓰면 좋을 것 같아요. "
          "특별한 투자 기회보다는 현재 가진 것을 지키는 데 집중하는 것이 현명합니다.\n\n"
          "💡 재물 팁: 불필요한 구독 서비스나 자동결제를 점검해보세요. "
          "작은 절약이 모여 큰 돈이 됩니다. 온라인 쇼핑이나 배달 주문은 최소화하고, "
          "집에 있는 식재료로 요리해보는 건 어떨까요? "
          "친구들과의 약속도 비용이 많이 드는 장소보다는 산책이나 공원 나들이를 추천해요.";
    } else {
      moneyContent = "💸 오늘은 지갑을 꼭 잡고 있어야 할 날이에요.\n\n"
          "재물운이 다소 약한 시기입니다. 불필요한 소비는 과감히 줄이세요. "
          "특히 충동구매나 세일 유혹에 넘어가지 않도록 주의가 필요합니다. "
          "지금은 쓰는 것보다 모으는 것에 집중해야 할 때예요.\n\n"
          "💡 재물 팁: 현금보다는 카드를 집에 두고 나가세요. "
          "쇼핑 앱이나 배달 앱을 오늘은 열지 않는 것이 좋습니다. "
          "투자 제안이나 사업 권유가 들어와도 섣불리 결정하지 말고 며칠 후로 미루세요. "
          "친구에게 돈을 빌려달라는 부탁도 정중히 거절하는 것이 서로를 위한 길입니다. "
          "대신 무료 문화행사나 도서관 방문으로 알찬 하루를 보내보세요.";
    }
    moneyScore = min(100, moneyScore);

    // Work Fortune (직장운)
    int workScore = 50 + random.nextInt(40) + baseBonus;
    String workContent;
    if (workScore >= 85) {
      workContent = "💼 업무 효율이 최고조예요!\n\n"
          "당신의 관록운과 식신운이 활발하게 작용하고 있습니다. "
          "중요한 프로젝트나 발표가 있다면 오늘이 최적의 날이에요. "
          "상사나 클라이언트에게 좋은 인상을 남길 수 있으며, 승진이나 인센티브를 기대해볼 수 있습니다.\n\n"
          "💡 업무 팁: 오전에 중요한 업무를 집중적으로 처리하세요. "
          "회의에서는 당신의 의견을 적극적으로 개진하면 좋은 반응을 얻을 수 있습니다. "
          "새로운 프로젝트 제안이나 아이디어가 있다면 오늘 발표해보세요. "
          "동료들과의 소통도 원활하니 협업이 필요한 일을 추진하기 좋습니다. "
          "학생이라면 발표 과제나 팀 프로젝트에서 리더 역할을 맡아보세요!";
    } else if (workScore >= 70) {
      workContent = "📊 일이 순조롭게 풀리는 날이에요.\n\n"
          "오늘의 직장운이 안정적으로 흐르고 있습니다. "
          "동료들과의 협업도 잘 될 거예요. 복잡했던 문제들이 하나씩 해결되면서 "
          "마음이 편안해질 것입니다. 밀린 업무를 정리하기에도 좋은 날이에요.\n\n"
          "💡 업무 팁: 루틴한 업무를 효율적으로 처리하면서 다음 주 계획을 세워보세요. "
          "상사에게 진행 상황을 보고하거나 피드백을 요청하면 긍정적인 반응을 얻을 수 있습니다. "
          "점심시간에 동료들과 식사하면서 친목을 다지는 것도 좋아요. "
          "학생이라면 복습과 과제 정리에 집중하면 좋은 성과를 얻을 수 있습니다.";
    } else if (workScore >= 50) {
      workContent = "📝 무난한 업무운이에요.\n\n"
          "오늘은 큰 변화 없이 평범한 하루가 될 것입니다. "
          "급하게 서두르지 말고 차근차근 진행하세요. "
          "새로운 일을 시작하기보다는 기존 업무를 마무리하는 데 집중하는 것이 좋습니다.\n\n"
          "💡 업무 팁: 체크리스트를 만들어 하나씩 완료해나가세요. "
          "중요한 결정이나 계약은 며칠 미루는 것이 안전합니다. "
          "상사나 동료와의 불필요한 마찰을 피하고 조용히 자기 일에 집중하세요. "
          "점심 후 컨디션이 떨어질 수 있으니 가벼운 산책이나 스트레칭으로 리프레시하세요. "
          "학생이라면 강의 노트를 정리하거나 기본 개념을 복습하는 시간을 가져보세요.";
    } else {
      workContent = "⚠️ 조금 힘들 수 있는 하루예요.\n\n"
          "업무 운이 다소 약한 시기입니다. 실수하지 않도록 꼼꼼히 확인하는 습관을 들이세요. "
          "상사나 동료와의 소통에서 오해가 생길 수 있으니 말을 신중하게 선택해야 합니다. "
          "급한 일은 가급적 내일로 미루는 것도 방법입니다.\n\n"
          "💡 업무 팁: 이메일이나 문서를 보내기 전에 두세 번 검토하세요. "
          "중요한 미팅이나 발표는 가능하면 다음 주로 조정하는 것이 좋습니다. "
          "스트레스를 받더라도 감정적으로 반응하지 말고 심호흡을 하며 진정하세요. "
          "퇴근 후에는 충분한 휴식을 취하며 내일을 준비하세요. "
          "학생이라면 무리하게 새로운 내용을 공부하기보다는 이미 배운 것을 복습하는 데 집중하세요.";
    }
    workScore = min(100, workScore);

    // Health Fortune (건강운)
    int healthScore = 50 + random.nextInt(40) + baseBonus;
    String healthContent;
    if (healthScore >= 85) {
      healthContent = "💪 컨디션이 최상이에요!\n\n"
          "당신의 생명력을 나타내는 기운이 충만합니다. "
          "운동이나 등산 같은 활동적인 일정을 잡아도 좋아요. "
          "체력이 넘치는 날이니 평소 미뤄두었던 격렬한 운동이나 스포츠 활동에 도전해보세요.\n\n"
          "💡 건강 팁: 아침 조깅이나 헬스장에서 고강도 운동을 해보세요. "
          "등산이나 하이킹을 계획하고 있다면 오늘이 최적의 날입니다. "
          "몸이 가벼워 평소보다 더 많은 활동을 소화할 수 있지만, 무리는 금물이에요. "
          "영양가 있는 식사와 충분한 수분 섭취로 에너지를 보충하세요. "
          "저녁에는 요가나 스트레칭으로 마무리하면 숙면에 도움이 됩니다.";
    } else if (healthScore >= 70) {
      healthContent = "🌟 건강 상태가 양호해요.\n\n"
          "오늘의 건강운이 안정적입니다. 큰 문제없이 활기찬 하루를 보낼 수 있어요. "
          "가벼운 스트레칭이나 산책으로 몸을 풀어주세요. "
          "규칙적인 생활 리듬을 유지하면 더욱 좋은 컨디션을 유지할 수 있습니다.\n\n"
          "💡 건강 팁: 30분 정도 빠르게 걷기나 가벼운 조깅을 추천합니다. "
          "계단을 이용하거나 한 정거장 먼저 내려 걸어보는 것도 좋아요. "
          "식사는 규칙적으로 하되, 과식은 피하고 채소와 과일을 충분히 섭취하세요. "
          "업무 중간중간 스트레칭으로 굳은 근육을 풀어주면 피로가 덜 쌓입니다. "
          "저녁에는 따뜻한 물로 반신욕을 하면 혈액순환에 도움이 됩니다.";
    } else if (healthScore >= 50) {
      healthContent = "😌 평범한 건강운이에요.\n\n"
          "오늘은 피로가 조금 쌓일 수 있어요. 무리한 활동보다는 적당한 휴식이 필요합니다. "
          "충분한 수분 섭취를 챙기고, 규칙적인 식사로 컨디션을 유지하세요. "
          "몸이 보내는 신호에 귀 기울이는 것이 중요합니다.\n\n"
          "💡 건강 팁: 격렬한 운동은 피하고 가벼운 산책이나 스트레칭 정도로 마무리하세요. "
          "카페인과 당분 섭취를 줄이고, 물을 자주 마시는 것이 좋습니다. "
          "점심 후 10-15분 정도 눈을 감고 휴식을 취하면 오후 컨디션이 좋아집니다. "
          "목과 어깨가 뭉칠 수 있으니 틈틈이 스트레칭 해주세요. "
          "저녁 식사는 가볍게 하고, 일찍 잠자리에 드는 것을 추천합니다.";
    } else {
      healthContent = "⚠️ 무리하지 마세요.\n\n"
          "건강운이 다소 약한 시기입니다. 오늘은 몸이 보내는 신호에 귀 기울이고 푹 쉬는 게 중요해요. "
          "무리한 일정이나 야근은 가능하면 피하고, 충분한 휴식을 취하세요. "
          "컨디션이 떨어지면 면역력도 약해질 수 있으니 주의가 필요합니다.\n\n"
          "💡 건강 팁: 오늘은 운동을 쉬고 집에서 편안하게 보내세요. "
          "따뜻한 차와 영양가 있는 음식으로 몸을 보살피는 것이 좋습니다. "
          "특히 소화기계통이 약해질 수 있으니 자극적인 음식은 피하고 소화가 잘 되는 음식을 드세요. "
          "목과 허리, 관절 부위를 따뜻하게 유지하세요. "
          "일찍 잠자리에 들어 최소 7-8시간 수면을 취하는 것이 회복에 도움이 됩니다. "
          "증상이 계속되면 병원 방문을 고려하세요.";
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
