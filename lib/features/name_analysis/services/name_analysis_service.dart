/// 이름 풀이 서비스
class NameAnalysisService {
  // 한글 초성 획수 (ㄱ, ㄲ, ㄴ, ㄷ, ㄸ, ㄹ, ㅁ, ㅂ, ㅃ, ㅅ, ㅆ, ㅇ, ㅈ, ㅉ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ)
  static const List<int> _chosungStrokes = [
    2, 4, 2, 3, 6, 5, 4, 4, 8, 2, 4, 1, 3, 6, 4, 3, 4, 4, 3
  ];

  // 한글 중성 획수 (ㅏ, ㅐ, ㅑ, ㅒ, ㅓ, ㅔ, ㅕ, ㅖ, ㅗ, ㅘ, ㅙ, ㅚ, ㅛ, ㅜ, ㅝ, ㅞ, ㅟ, ㅠ, ㅡ, ㅢ, ㅣ)
  static const List<int> _jungsungStrokes = [
    2, 3, 3, 4, 2, 3, 3, 4, 2, 4, 5, 3, 3, 2, 4, 5, 3, 3, 1, 2, 1
  ];

  // 한글 종성 획수 (없음, ㄱ, ㄲ, ㄳ, ㄴ, ㄵ, ㄶ, ㄷ, ㄹ, ㄺ, ㄻ, ㄼ, ㄽ, ㄾ, ㄿ, ㅀ, ㅁ, ㅂ, ㅄ, ㅅ, ㅆ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ)
  static const List<int> _jongsungStrokes = [
    0, 2, 4, 4, 2, 5, 5, 3, 5, 7, 9, 9, 7, 9, 9, 8, 4, 4, 6, 2, 4, 1, 3, 4, 3, 4, 4, 3
  ];

  // 81수리 해설 (간략 버전)
  static const Map<int, String> _suri81 = {
    1: '시작이 좋고 만사가 형통하니 부귀영화를 누릴 운세입니다.',
    3: '지혜와 용기를 겸비하여 대업을 성취할 길한 운세입니다.',
    5: '덕망이 있고 재물이 따르니 성공할 운세입니다.',
    6: '조상의 음덕으로 평생 안락하게 지낼 운세입니다.',
    7: '독립심이 강하고 끈기가 있어 자수성가할 운세입니다.',
    8: '의지가 굳고 노력하여 마침내 성공을 거둘 운세입니다.',
    11: '재능이 뛰어나고 운세가 창성하니 부귀를 누릴 운세입니다.',
    13: '지혜가 출중하고 학문과 예술에 재능이 있는 운세입니다.',
    15: '덕망이 높고 인복이 많아 사회적으로 존경받을 운세입니다.',
    16: '인덕이 있고 재물이 풍족하니 부귀영화를 누릴 운세입니다.',
    17: '의지가 강하고 결단력이 있어 난관을 극복하고 성공할 운세입니다.',
    18: '지모가 뛰어나고 활동적이어서 큰 뜻을 이룰 운세입니다.',
    21: '독립심이 강하고 리더십이 있어 지도자가 될 운세입니다.',
    23: '기상이 웅대하고 재물이 왕성하니 크게 성공할 운세입니다.',
    24: '지혜와 재능을 겸비하여 자수성가하고 부귀를 누릴 운세입니다.',
    25: '성품이 온화하고 재주가 뛰어나 평생 안락할 운세입니다.',
    29: '지혜가 뛰어나고 활동적이나 욕심을 부리면 실패할 수 있습니다.',
    31: '의지가 굳고 인내심이 강하여 마침내 대업을 이룰 운세입니다.',
    32: '인덕이 있고 재물이 따르니 평생 풍요롭게 지낼 운세입니다.',
    33: '재능이 뛰어나고 권세를 누리니 명성을 떨칠 운세입니다.',
    35: '성품이 온화하고 학문과 예술에 재능이 있어 성공할 운세입니다.',
    37: '독립심이 강하고 성실하여 자수성가할 운세입니다.',
    38: '재능이 뛰어나고 예술적 감각이 있어 명성을 얻을 운세입니다.',
    39: '부귀영화를 누리나 건강에 유의해야 할 운세입니다.',
    41: '지혜가 뛰어나고 덕망이 있어 지도자가 될 운세입니다.',
    45: '지혜와 용기를 겸비하여 난관을 극복하고 성공할 운세입니다.',
    47: '재물이 풍족하고 자손이 번창하니 말년이 행복할 운세입니다.',
    48: '지혜가 뛰어나고 인덕이 있어 사회적으로 존경받을 운세입니다.',
    52: '의지가 굳고 선견지명이 있어 대업을 성취할 운세입니다.',
    57: '인내심이 강하고 노력하여 마침내 성공을 거둘 운세입니다.',
    61: '재물이 풍족하고 명예를 얻으니 부귀영화를 누릴 운세입니다.',
    63: '지혜와 덕망을 겸비하여 사회적으로 성공할 운세입니다.',
    65: '성품이 온화하고 인덕이 있어 평생 안락할 운세입니다.',
    67: '독립심이 강하고 재주가 뛰어나 자수성가할 운세입니다.',
    68: '지혜가 뛰어나고 창의력이 있어 발명이나 예술로 성공할 운세입니다.',
    // 나머지는 기본 운세로 처리
  };

  /// 한글 이름의 총 획수 계산
  int calculateTotalStrokes(String name) {
    int totalStrokes = 0;
    for (int i = 0; i < name.length; i++) {
      totalStrokes += _getCharStrokes(name.codeUnitAt(i));
    }
    return totalStrokes;
  }

  /// 개별 글자의 획수 계산
  int _getCharStrokes(int charCode) {
    // 한글 유니코드 범위: 0xAC00(가) ~ 0xD7A3(힣)
    if (charCode < 0xAC00 || charCode > 0xD7A3) return 0;

    int unicodeIndex = charCode - 0xAC00;
    int chosungIndex = unicodeIndex ~/ (21 * 28);
    int jungsungIndex = (unicodeIndex % (21 * 28)) ~/ 28;
    int jongsungIndex = unicodeIndex % 28;

    return _chosungStrokes[chosungIndex] +
        _jungsungStrokes[jungsungIndex] +
        _jongsungStrokes[jongsungIndex];
  }

  /// 이름 분석 결과 반환
  NameAnalysisResult analyzeName(String name) {
    // 1. 총 획수 계산
    int totalStrokes = calculateTotalStrokes(name);
    
    // 2. 81수리 적용 (81로 나눈 나머지, 0이면 81)
    int suriIndex = totalStrokes % 81;
    if (suriIndex == 0) suriIndex = 81;

    // 3. 해설 조회
    String fortune = _suri81[suriIndex] ?? '노력하면 반드시 대가를 얻는 평범하지만 견실한 운세입니다. 성실함이 당신의 가장 큰 무기입니다.';
    
    // 4. 오행 분석 (초성 기반)
    // ㄱ,ㅋ: 목 / ㄴ,ㄷ,ㄹ,ㅌ: 화 / ㅇ,ㅎ: 토 / ㅅ,ㅈ,ㅊ: 금 / ㅁ,ㅂ,ㅍ: 수
    // (일반적인 훈민정음 해례본 기준과 다를 수 있으나 작명학 통용 기준 적용)
    // 작명학 통설:
    // 목: ㄱ, ㅋ
    // 화: ㄴ, ㄷ, ㄹ, ㅌ
    // 토: ㅇ, ㅎ
    // 금: ㅅ, ㅈ, ㅊ
    // 수: ㅁ, ㅂ, ㅍ
    
    List<String> ohaengList = [];
    for (int i = 0; i < name.length; i++) {
      int charCode = name.codeUnitAt(i);
      if (charCode < 0xAC00 || charCode > 0xD7A3) continue;
      
      int unicodeIndex = charCode - 0xAC00;
      int chosungIndex = unicodeIndex ~/ (21 * 28);
      
      // 초성 인덱스: 0:ㄱ, 1:ㄲ, 2:ㄴ, 3:ㄷ, 4:ㄸ, 5:ㄹ, 6:ㅁ, 7:ㅂ, 8:ㅃ, 9:ㅅ, 10:ㅆ, 11:ㅇ, 12:ㅈ, 13:ㅉ, 14:ㅊ, 15:ㅋ, 16:ㅌ, 17:ㅍ, 18:ㅎ
      if ([0, 1, 15].contains(chosungIndex)) ohaengList.add('목(木)');
      else if ([2, 3, 4, 5, 16].contains(chosungIndex)) ohaengList.add('화(火)');
      else if ([11, 18].contains(chosungIndex)) ohaengList.add('토(土)');
      else if ([9, 10, 12, 13, 14].contains(chosungIndex)) ohaengList.add('금(金)');
      else if ([6, 7, 8, 17].contains(chosungIndex)) ohaengList.add('수(水)');
    }

    return NameAnalysisResult(
      name: name,
      totalStrokes: totalStrokes,
      suriIndex: suriIndex,
      fortune: fortune,
      ohaeng: ohaengList,
    );
  }
}

class NameAnalysisResult {
  final String name;
  final int totalStrokes;
  final int suriIndex;
  final String fortune;
  final List<String> ohaeng;

  NameAnalysisResult({
    required this.name,
    required this.totalStrokes,
    required this.suriIndex,
    required this.fortune,
    required this.ohaeng,
  });
}
