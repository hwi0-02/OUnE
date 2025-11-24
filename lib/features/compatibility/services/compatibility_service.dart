import 'package:app_project/core/utils/saju_engine.dart';
import 'dart:math';

/// 사주 궁합 서비스
class CompatibilityService {
  /// 두 사람의 생년월일을 기반으로 궁합 분석
  CompatibilityResult analyzeCompatibility({
    required DateTime birthDate1,
    required DateTime birthDate2,
    required String name1,
    required String name2,
  }) {
    // 1. 각자의 일간(Day Master) 추출
    final dayGanJi1 = SajuEngine.getDayGanJi(birthDate1);
    final dayGanJi2 = SajuEngine.getDayGanJi(birthDate2);
    
    final dayGan1 = dayGanJi1.substring(0, 1);
    final dayGan2 = dayGanJi2.substring(0, 1);
    
    // 2. 오행 추출
    final ohaeng1 = SajuEngine.getOhaeng(dayGan1);
    final ohaeng2 = SajuEngine.getOhaeng(dayGan2);
    
    // 3. 오행 관계 분석
    final relationship = SajuEngine.getOhaengRelationship(ohaeng1, ohaeng2);
    
    // 4. 점수 계산 (기본 70점 + 관계 점수)
    int score = 70;
    String summary = '';
    
    if (relationship.contains('상생')) {
      score += 20;
      summary = '서로의 기운을 북돋아주는 환상의 짝꿍이에요!';
    } else if (relationship.contains('같은')) {
      score += 15;
      summary = '비슷한 성향을 가진 친구 같은 관계예요.';
    } else if (relationship.contains('도움')) {
      score += 18;
      summary = '서로 부족한 점을 채워주는 좋은 관계예요.';
    } else {
      score += 5;
      summary = '서로 다른 매력에 끌리는 관계예요. 이해와 배려가 필요해요.';
    }
    
    // 5. 추가 변동 (생년월일 해시값으로 약간의 변동 추가)
    final hash = (birthDate1.year + birthDate2.year + birthDate1.month + birthDate2.month) % 10;
    score = (score + hash - 5).clamp(0, 100); // ±5점 변동
    
    // 6. 세부 조언 생성
    final advice = _generateAdvice(ohaeng1, ohaeng2, name1, name2);

    return CompatibilityResult(
      name1: name1,
      name2: name2,
      score: score,
      summary: summary,
      advice: advice,
      myOhaeng: ohaeng1,
      partnerOhaeng: ohaeng2,
    );
  }

  String _generateAdvice(String ohaeng1, String ohaeng2, String name1, String name2) {
    if (ohaeng1 == ohaeng2) {
      return '두 분은 성향이 비슷해서 말이 잘 통하지만, 고집을 부릴 때도 비슷할 수 있어요. 서로의 의견을 존중하는 것이 중요합니다.';
    }
    
    // 상생 관계 (목->화->토->금->수->목)
    final isSangsaeng = 
        (ohaeng1 == '목' && ohaeng2 == '화') || (ohaeng1 == '화' && ohaeng2 == '토') ||
        (ohaeng1 == '토' && ohaeng2 == '금') || (ohaeng1 == '금' && ohaeng2 == '수') ||
        (ohaeng1 == '수' && ohaeng2 == '목');
        
    if (isSangsaeng) {
      return '$name1님이 $name2님에게 힘이 되어주는 관계입니다. $name1님의 배려가 관계를 더욱 돈독하게 만들 거예요.';
    }
    
    // 역상생
    final isReverseSangsaeng = 
        (ohaeng2 == '목' && ohaeng1 == '화') || (ohaeng2 == '화' && ohaeng1 == '토') ||
        (ohaeng2 == '토' && ohaeng1 == '금') || (ohaeng2 == '금' && ohaeng1 == '수') ||
        (ohaeng2 == '수' && ohaeng1 == '목');
        
    if (isReverseSangsaeng) {
      return '$name2님이 $name1님을 잘 챙겨주는 관계입니다. 고마움을 표현하면 더 좋은 관계가 될 거예요.';
    }
    
    return '서로 다른 관점을 가지고 있어 배울 점이 많습니다. 차이를 인정하고 대화로 풀어가면 훌륭한 파트너가 될 수 있어요.';
  }
  
  // 임시 변수 처리를 위해 getter로 변경하거나 파라미터로 받아야 하는데, 
  // 위 _generateAdvice 메서드 내에서 name1, name2를 사용할 수 없으므로 
  // 텍스트를 일반화하여 수정합니다.
}

class CompatibilityResult {
  final String name1;
  final String name2;
  final int score;
  final String summary;
  final String advice;
  final String myOhaeng;
  final String partnerOhaeng;

  CompatibilityResult({
    required this.name1,
    required this.name2,
    required this.score,
    required this.summary,
    required this.advice,
    required this.myOhaeng,
    required this.partnerOhaeng,
  });
}
