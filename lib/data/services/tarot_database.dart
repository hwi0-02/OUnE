class TarotCard {
  final int id;
  final String name;
  final String nameKr;
  final String uprightKeywords;
  final String reversedKeywords;
  final String uprightMessage;
  final String reversedMessage;

  const TarotCard({
    required this.id,
    required this.name,
    required this.nameKr,
    required this.uprightKeywords,
    required this.reversedKeywords,
    required this.uprightMessage,
    required this.reversedMessage,
  });
}

class TarotDatabase {
  static const List<TarotCard> majorArcana = [
    TarotCard(
      id: 0,
      name: 'The Fool',
      nameKr: '바보',
      uprightKeywords: '새로운 시작, 모험, 순수함, 자유',
      reversedKeywords: '무모함, 방향성 상실, 경솔함',
      uprightMessage: '새로운 시작의 에너지가 느껴져! 두려워하지 말고 한 걸음 내딛어봐 ♡',
      reversedMessage: '지금은 조금 신중하게 생각할 때야. 서두르지 말고 준비를 더 해보는 게 어때? 💙',
    ),
    TarotCard(
      id: 1,
      name: 'The Magician',
      nameKr: '마법사',
      uprightKeywords: '창의성, 능력, 의지력, 실행',
      reversedKeywords: '재능 낭비, 자신감 부족, 조작',
      uprightMessage: '너의 재능을 마음껏 발휘할 시간이야! 원하는 걸 현실로 만들어봐 ✨',
      reversedMessage: '능력을 제대로 활용하지 못하고 있어. 자신감을 가지고 다시 시작해보자!',
    ),
    TarotCard(
      id: 2,
      name: 'The High Priestess',
      nameKr: '여사제',
      uprightKeywords: '직관, 지혜, 비밀, 내면의 목소리',
      reversedKeywords: '직관 무시, 비밀 폭로, 감정 억압',
      uprightMessage: '내면의 목소리에 귀 기울여봐. 너의 직관이 정답을 알고 있어 🌙',
      reversedMessage: '직관을 무시하고 있지 않아? 마음 깊은 곳의 소리를 다시 들어봐.',
    ),
    TarotCard(
      id: 3,
      name: 'The Empress',
      nameKr: '여황제',
      uprightKeywords: '풍요, 사랑, 모성, 창조력',
      reversedKeywords: '의존, 질식, 창의력 부족',
      uprightMessage: '풍요롭고 사랑이 가득한 시간이 기다리고 있어. 마음껏 누려봐! 💕',
      reversedMessage: '너무 보호받거나 의존하고 있진 않아? 스스로 설 힘이 필요해.',
    ),
    TarotCard(
      id: 4,
      name: 'The Emperor',
      nameKr: '황제',
      uprightKeywords: '권위, 안정, 질서, 리더십',
      reversedKeywords: '독재, 경직성, 통제 과다',
      uprightMessage: '안정과 질서를 만들어낼 시간이야. 네가 리더가 되어봐! 👑',
      reversedMessage: '너무 통제하려고 하지 않아? 유연함도 필요한 때야.',
    ),
    TarotCard(
      id: 5,
      name: 'The Hierophant',
      nameKr: '교황',
      uprightKeywords: '전통, 가르침, 종교, 신념',
      reversedKeywords: '고정관념, 반항, 관습 거부',
      uprightMessage: '전통적인 방법이나 가르침 속에 답이 있어. 배움을 열어봐 📚',
      reversedMessage: '기존 관념에서 벗어나 새로운 길을 찾아보는 건 어때?',
    ),
    TarotCard(
      id: 6,
      name: 'The Lovers',
      nameKr: '연인',
      uprightKeywords: '선택, 사랑, 화합, 파트너십',
      reversedKeywords: '갈등, 불균형, 선택 회피',
      uprightMessage: '사랑과 선택의 에너지가 강한 날이야. 마음이 가는 쪽으로 용기내봐! ♡',
      reversedMessage: '관계에서 균형이 깨졌어. 솔직한 대화가 필요한 시간이야.',
    ),
    TarotCard(
      id: 7,
      name: 'The Chariot',
      nameKr: '전차',
      uprightKeywords: '승리, 의지력, 행동, 통제',
      reversedKeywords: '방향성 상실, 좌절, 충동',
      uprightMessage: '목표를 향해 전진할 시간이야! 의지를 가지면 이룰 수 있어 🚀',
      reversedMessage: '방향을 잃었다면 잠시 멈춰서 다시 생각해보자.',
    ),
    TarotCard(
      id: 8,
      name: 'Strength',
      nameKr: '힘',
      uprightKeywords: '용기, 인내, 자제력, 내면의 힘',
      reversedKeywords: '자신감 부족, 의심, 무기력',
      uprightMessage: '너에겐 힘이 있어. 부드럽지만 강하게, 용기 내봐! 💪',
      reversedMessage: '자신감이 흔들리고 있어. 내면의 힘을 다시 믿어봐.',
    ),
    TarotCard(
      id: 9,
      name: 'The Hermit',
      nameKr: '은둔자',
      uprightKeywords: '성찰, 고독, 지혜, 내면 탐구',
      reversedKeywords: '고립, 외로움, 도피',
      uprightMessage: '혼자만의 시간이 필요해. 내면을 돌아보고 지혜를 찾아봐 🕯️',
      reversedMessage: '너무 오래 혼자 있었어. 이제 세상으로 나갈 시간이야.',
    ),
    TarotCard(
      id: 10,
      name: 'Wheel of Fortune',
      nameKr: '운명의 수레바퀴',
      uprightKeywords: '행운, 변화, 순환, 운명',
      reversedKeywords: '불운, 저항, 통제 불능',
      uprightMessage: '행운의 바퀴가 돌아가고 있어! 좋은 변화가 올 거야 🎡',
      reversedMessage: '운이 좋지 않더라도 괜찮아. 이것 역시 지나갈 거야.',
    ),
    TarotCard(
      id: 11,
      name: 'Justice',
      nameKr: '정의',
      uprightKeywords: '공정함, 진실, 균형, 책임',
      reversedKeywords: '불공정, 거짓, 책임 회피',
      uprightMessage: '공정한 판단의 시간이야. 진실은 항상 빛을 발해 ⚖️',
      reversedMessage: '불공정한 일이 있다면 목소리를 내야 할 때야.',
    ),
    TarotCard(
      id: 12,
      name: 'The Hanged Man',
      nameKr: '매달린 사람',
      uprightKeywords: '희생, 관점 전환, 기다림, 깨달음',
      reversedKeywords: '지연, 저항, 희생 거부',
      uprightMessage: '다른 관점에서 보면 답이 보여. 잠시 멈추고 기다려봐 🙃',
      reversedMessage: '더 이상 희생할 필요 없어. 행동할 때야.',
    ),
    TarotCard(
      id: 13,
      name: 'Death',
      nameKr: '죽음',
      uprightKeywords: '변화, 끝, 새로운 시작, 변형',
      reversedKeywords: '변화 거부, 정체, 집착',
      uprightMessage: '끝이 곧 새로운 시작이야. 변화를 받아들여봐 🦋',
      reversedMessage: '변화를 두려워하고 있어. 놓아주는 것도 용기야.',
    ),
    TarotCard(
      id: 14,
      name: 'Temperance',
      nameKr: '절제',
      uprightKeywords: '균형, 조화, 인내, 자제',
      reversedKeywords: '과잉, 불균형, 조급함',
      uprightMessage: '균형과 조화가 필요해. 중도의 길을 걸어봐 ⚖️',
      reversedMessage: '어느 한쪽으로 치우쳤어. 균형을 다시 찾자.',
    ),
    TarotCard(
      id: 15,
      name: 'The Devil',
      nameKr: '악마',
      uprightKeywords: '집착, 유혹, 물질주의, 속박',
      reversedKeywords: '해방, 자유, 통제 회복',
      uprightMessage: '무언가에 너무 집착하고 있진 않아? 스스로를 돌아봐 😈',
      reversedMessage: '속박에서 벗어날 시간이야. 자유를 되찾을 수 있어!',
    ),
    TarotCard(
      id: 16,
      name: 'The Tower',
      nameKr: '탑',
      uprightKeywords: '충격, 파괴, 급변, 깨달음',
      reversedKeywords: '파국 회피, 지연된 변화, 내면의 변화',
      uprightMessage: '갑작스런 변화가 올 수 있어. 두려워하지 말고 받아들여 ⚡',
      reversedMessage: '큰 변화를 피하고 있어. 하지만 결국 마주해야 해.',
    ),
    TarotCard(
      id: 17,
      name: 'The Star',
      nameKr: '별',
      uprightKeywords: '희망, 영감, 평온, 치유',
      reversedKeywords: '절망, 희망 상실, 비관',
      uprightMessage: '희망의 빛이 보여! 꿈을 향해 나아가봐 ⭐',
      reversedMessage: '희망을 잃었다면 다시 별을 올려다봐. 빛은 항상 있어.',
    ),
    TarotCard(
      id: 18,
      name: 'The Moon',
      nameKr: '달',
      uprightKeywords: '환상, 직관, 두려움, 무의식',
      reversedKeywords: '진실 발견, 명료함, 두려움 극복',
      uprightMessage: '모든 게 명확하지 않아도 괜찮아. 직관을 믿어봐 🌙',
      reversedMessage: '혼란이 걷히고 진실이 드러날 거야. 두려워 말고 앞으로!',
    ),
    TarotCard(
      id: 19,
      name: 'The Sun',
      nameKr: '태양',
      uprightKeywords: '기쁨, 성공, 활력, 명료함',
      reversedKeywords: '낙관 과다, 지연된 성공, 우울',
      uprightMessage: '밝고 긍정적인 에너지가 가득해! 최고의 순간이야 ☀️',
      reversedMessage: '조금 흐릴 수 있지만 곧 태양이 다시 떠올라. 조금만 기다려!',
    ),
    TarotCard(
      id: 20,
      name: 'Judgement',
      nameKr: '심판',
      uprightKeywords: '심판, 재탄생, 용서, 각성',
      reversedKeywords: '자기 비난, 의심, 용서 거부',
      uprightMessage: '새롭게 태어날 시간이야. 과거를 용서하고 앞으로 나아가 📯',
      reversedMessage: '스스로를 너무 가혹하게 심판하지 마. 용서가 필요해.',
    ),
    TarotCard(
      id: 21,
      name: 'The World',
      nameKr: '세계',
      uprightKeywords: '완성, 성취, 성공, 통합',
      reversedKeywords: '미완성, 지연, 정체',
      uprightMessage: '완성과 성취의 순간이야! 축하해, 정말 잘했어! 🌍',
      reversedMessage: '거의 다 왔어. 마지막 한 걸음만 더 가보자!',
    ),
  ];

  static TarotCard getCardById(int id) {
    return majorArcana.firstWhere((card) => card.id == id);
  }

  static TarotCard getRandomCard() {
    final random = DateTime.now().millisecondsSinceEpoch % 22;
    return majorArcana[random];
  }
}
