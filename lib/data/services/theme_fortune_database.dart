import 'package:flutter/material.dart';
import 'package:app_project/core/utils/deterministic_random.dart';

class ThemeFortune {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const ThemeFortune({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class ThemeFortuneDatabase {
  static const List<ThemeFortune> themes = [
    ThemeFortune(
      id: 'move',
      title: '이사운',
      icon: Icons.home,
      color: Colors.orange,
      description: '새로운 보금자리로의 이동, 언제가 좋을까요?',
    ),
    ThemeFortune(
      id: 'exam',
      title: '시험운',
      icon: Icons.edit_document,
      color: Colors.blue,
      description: '합격의 기운이 들어오는 시기를 알려드려요.',
    ),
    ThemeFortune(
      id: 'travel',
      title: '여행운',
      icon: Icons.flight_takeoff,
      color: Colors.teal,
      description: '안전하고 즐거운 여행을 위한 조언.',
    ),
    ThemeFortune(
      id: 'contract',
      title: '계약운',
      icon: Icons.handshake,
      color: Colors.purple,
      description: '중요한 계약 전, 반드시 확인해보세요.',
    ),
    ThemeFortune(
      id: 'lawsuit',
      title: '소송운',
      icon: Icons.gavel,
      color: Colors.red,
      description: '법적인 문제, 어떻게 해결될까요?',
    ),
    ThemeFortune(
      id: 'interview',
      title: '면접운',
      icon: Icons.people,
      color: Colors.indigo,
      description: '면접관의 마음을 사로잡는 비결.',
    ),
    ThemeFortune(
      id: 'promotion',
      title: '승진운',
      icon: Icons.trending_up,
      color: Colors.green,
      description: '직장에서 인정받고 승진할 수 있을까요?',
    ),
    ThemeFortune(
      id: 'business',
      title: '사업운',
      icon: Icons.store,
      color: Colors.amber,
      description: '사업 확장이나 창업, 지금이 적기일까요?',
    ),
    ThemeFortune(
      id: 'health_diet',
      title: '다이어트',
      icon: Icons.monitor_weight,
      color: Colors.pink,
      description: '성공적인 다이어트를 위한 팁.',
    ),
    ThemeFortune(
      id: 'pet',
      title: '반려동물',
      icon: Icons.pets,
      color: Colors.brown,
      description: '나와 잘 맞는 반려동물은?',
    ),
    ThemeFortune(
      id: 'study',
      title: '학업운',
      icon: Icons.school,
      color: Colors.cyan,
      description: '성적 향상을 위한 공부 비법.',
    ),
    ThemeFortune(
      id: 'friend',
      title: '대인관계',
      icon: Icons.diversity_3,
      color: Colors.deepOrange,
      description: '주변 사람들과의 관계를 개선하려면?',
    ),
  ];

  /// 테마별 운세 결과 생성 (Deterministic)
  static String getFortuneContent(String themeId, DateTime date) {
    final int seed = DeterministicRandom.fromDate(date, id: themeId);
    final int index = seed % 5; // 5가지 패턴 중 하나

    switch (themeId) {
      case 'move':
        return [
          '이동수가 아주 좋습니다. 새로운 환경이 당신에게 활력을 불어넣어 줄 것입니다. 남쪽 방향이 길합니다.',
          '지금은 현재의 자리를 지키는 것이 좋습니다. 무리한 이동은 오히려 화를 부를 수 있습니다.',
          '이사를 계획하고 있다면 꼼꼼하게 따져보세요. 겉보기와 달리 숨겨진 문제가 있을 수 있습니다.',
          '가까운 곳으로의 이동은 무난합니다. 하지만 먼 곳으로의 이동은 신중해야 합니다.',
          '이동하기에 적절한 시기가 아닙니다. 조금 더 기다리면 더 좋은 기회가 찾아올 것입니다.',
        ][index];
      case 'exam':
        return [
          '집중력이 최고조에 달하는 시기입니다. 노력한 만큼 좋은 결과가 있을 것입니다.',
          '실수만 조심하면 합격은 따 놓은 당상입니다. 차분한 마음을 유지하세요.',
          '경쟁률이 높을 수 있습니다. 남들보다 한 발 더 뛰는 노력이 필요합니다.',
          '예상치 못한 문제에 당황할 수 있습니다. 기출문제를 다시 한번 확인하세요.',
          '컨디션 조절이 관건입니다. 무리한 밤샘 공부보다는 충분한 휴식이 필요합니다.',
        ][index];
      // ... 다른 테마들에 대한 내용도 추가 가능 (여기서는 패턴화하여 간략히 처리)
      default:
        return [
          '운의 흐름이 당신을 돕고 있습니다. 자신감을 가지고 추진해보세요.',
          '조금은 신중할 필요가 있습니다. 돌다리도 두들겨 보고 건너세요.',
          '주변의 조언을 귀담아들으세요. 혼자 고민하는 것보다 훨씬 좋은 해결책을 찾을 수 있습니다.',
          '잠시 쉬어가는 것도 방법입니다. 재충전의 시간을 가지면 더 멀리 갈 수 있습니다.',
          '뜻밖의 행운이 찾아올 수 있습니다. 기회를 놓치지 않도록 준비하세요.',
        ][index];
    }
  }
}
