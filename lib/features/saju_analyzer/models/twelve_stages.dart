/// Twelve Stages (12운성)
/// 
/// Represents the strength/vitality of a heavenly stem in a specific earthly branch
/// Based on the life cycle metaphor from birth to death
enum TwelveStage {
  /// 장생 (長生) - Birth/Longevity
  /// Peak vitality, new beginnings
  jangSaeng,
  
  /// 목욕 (沐浴) - Bathing
  /// Vulnerability, cleansing, renewal
  mokYok,
  
  /// 관대 (冠帶) - Capping ceremony (coming of age)
  /// Maturity, responsibility
  gwanDae,
  
  /// 건록 (建祿) - Establishment
  /// Strong position, self-reliance
  geonRok,
  
  /// 제왕 (帝旺) - Emperor/Peak
  /// Maximum power and influence
  jeWang,
  
  /// 쇠 (衰) - Decline
  /// Beginning of weakening
  쇠,
  
  /// 병 (病) - Illness
  /// Weakened state
  byeong,
  
  /// 사 (死) - Death
  /// Loss of vitality
  sa,
  
  /// 묘 (墓) - Tomb/Storage
  /// Hidden, stored energy
  myo,
  
  /// 절 (絕) - Extinction
  /// Minimal energy
  jeol,
  
  /// 태 (胎) - Conception
  /// Potential, planning
  tae,
  
  /// 양 (養) - Nurturing
  /// Growth, development
  yang,
}

/// Extension methods for TwelveStage
extension TwelveStageExtension on TwelveStage {
  /// Get Korean name
  String get koreanName {
    switch (this) {
      case TwelveStage.jangSaeng:
        return '장생';
      case TwelveStage.mokYok:
        return '목욕';
      case TwelveStage.gwanDae:
        return '관대';
      case TwelveStage.geonRok:
        return '건록';
      case TwelveStage.jeWang:
        return '제왕';
      case TwelveStage.쇠:
        return '쇠';
      case TwelveStage.byeong:
        return '병';
      case TwelveStage.sa:
        return '사';
      case TwelveStage.myo:
        return '묘';
      case TwelveStage.jeol:
        return '절';
      case TwelveStage.tae:
        return '태';
      case TwelveStage.yang:
        return '양';
    }
  }
  
  /// Get strength score (1-10)
  int get strengthScore {
    switch (this) {
      case TwelveStage.jeWang:
        return 10;
      case TwelveStage.geonRok:
        return 9;
      case TwelveStage.jangSaeng:
        return 8;
      case TwelveStage.gwanDae:
        return 7;
      case TwelveStage.yang:
        return 6;
      case TwelveStage.tae:
        return 5;
      case TwelveStage.쇠:
        return 4;
      case TwelveStage.mokYok:
        return 3;
      case TwelveStage.byeong:
        return 2;
      case TwelveStage.myo:
        return 2;
      case TwelveStage.sa:
        return 1;
      case TwelveStage.jeol:
        return 1;
    }
  }
  
  /// Get description
  String get description {
    switch (this) {
      case TwelveStage.jangSaeng:
        return '생명력 왕성, 새로운 시작';
      case TwelveStage.mokYok:
        return '불안정, 정화, 갱신';
      case TwelveStage.gwanDae:
        return '성숙, 책임감';
      case TwelveStage.geonRok:
        return '강한 위치, 자립';
      case TwelveStage.jeWang:
        return '최고의 힘과 영향력';
      case TwelveStage.쇠:
        return '쇠퇴 시작';
      case TwelveStage.byeong:
        return '약화된 상태';
      case TwelveStage.sa:
        return '활력 상실';
      case TwelveStage.myo:
        return '숨겨진 잠재력';
      case TwelveStage.jeol:
        return '최소 에너지';
      case TwelveStage.tae:
        return '잠재력, 계획';
      case TwelveStage.yang:
        return '성장, 발전';
    }
  }
}

/// Helper class to calculate Twelve Stages
class TwelveStageCalculator {
  /// Twelve Stages mapping table
  /// Key: Heavenly Stem (천간)
  /// Value: Map of Earthly Branch (지지) to TwelveStage
  static final Map<String, Map<String, TwelveStage>> _stageTable = {
    '갑': {
      '해': TwelveStage.jangSaeng,
      '자': TwelveStage.mokYok,
      '축': TwelveStage.gwanDae,
      '인': TwelveStage.geonRok,
      '묘': TwelveStage.jeWang,
      '진': TwelveStage.쇠,
      '사': TwelveStage.byeong,
      '오': TwelveStage.sa,
      '미': TwelveStage.myo,
      '신': TwelveStage.jeol,
      '유': TwelveStage.tae,
      '술': TwelveStage.yang,
    },
    '을': {
      '오': TwelveStage.jangSaeng,
      '사': TwelveStage.mokYok,
      '진': TwelveStage.gwanDae,
      '묘': TwelveStage.geonRok,
      '인': TwelveStage.jeWang,
      '축': TwelveStage.쇠,
      '자': TwelveStage.byeong,
      '해': TwelveStage.sa,
      '술': TwelveStage.myo,
      '유': TwelveStage.jeol,
      '신': TwelveStage.tae,
      '미': TwelveStage.yang,
    },
    '병': {
      '인': TwelveStage.jangSaeng,
      '묘': TwelveStage.mokYok,
      '진': TwelveStage.gwanDae,
      '사': TwelveStage.geonRok,
      '오': TwelveStage.jeWang,
      '미': TwelveStage.쇠,
      '신': TwelveStage.byeong,
      '유': TwelveStage.sa,
      '술': TwelveStage.myo,
      '해': TwelveStage.jeol,
      '자': TwelveStage.tae,
      '축': TwelveStage.yang,
    },
    '정': {
      '유': TwelveStage.jangSaeng,
      '신': TwelveStage.mokYok,
      '미': TwelveStage.gwanDae,
      '오': TwelveStage.geonRok,
      '사': TwelveStage.jeWang,
      '진': TwelveStage.쇠,
      '묘': TwelveStage.byeong,
      '인': TwelveStage.sa,
      '축': TwelveStage.myo,
      '자': TwelveStage.jeol,
      '해': TwelveStage.tae,
      '술': TwelveStage.yang,
    },
    '무': {
      '인': TwelveStage.jangSaeng,
      '묘': TwelveStage.mokYok,
      '진': TwelveStage.gwanDae,
      '사': TwelveStage.geonRok,
      '오': TwelveStage.jeWang,
      '미': TwelveStage.쇠,
      '신': TwelveStage.byeong,
      '유': TwelveStage.sa,
      '술': TwelveStage.myo,
      '해': TwelveStage.jeol,
      '자': TwelveStage.tae,
      '축': TwelveStage.yang,
    },
    '기': {
      '유': TwelveStage.jangSaeng,
      '신': TwelveStage.mokYok,
      '미': TwelveStage.gwanDae,
      '오': TwelveStage.geonRok,
      '사': TwelveStage.jeWang,
      '진': TwelveStage.쇠,
      '묘': TwelveStage.byeong,
      '인': TwelveStage.sa,
      '축': TwelveStage.myo,
      '자': TwelveStage.jeol,
      '해': TwelveStage.tae,
      '술': TwelveStage.yang,
    },
    '경': {
      '사': TwelveStage.jangSaeng,
      '오': TwelveStage.mokYok,
      '미': TwelveStage.gwanDae,
      '신': TwelveStage.geonRok,
      '유': TwelveStage.jeWang,
      '술': TwelveStage.쇠,
      '해': TwelveStage.byeong,
      '자': TwelveStage.sa,
      '축': TwelveStage.myo,
      '인': TwelveStage.jeol,
      '묘': TwelveStage.tae,
      '진': TwelveStage.yang,
    },
    '신': {
      '자': TwelveStage.jangSaeng,
      '해': TwelveStage.mokYok,
      '술': TwelveStage.gwanDae,
      '유': TwelveStage.geonRok,
      '신': TwelveStage.jeWang,
      '미': TwelveStage.쇠,
      '오': TwelveStage.byeong,
      '사': TwelveStage.sa,
      '진': TwelveStage.myo,
      '묘': TwelveStage.jeol,
      '인': TwelveStage.tae,
      '축': TwelveStage.yang,
    },
    '임': {
      '신': TwelveStage.jangSaeng,
      '유': TwelveStage.mokYok,
      '술': TwelveStage.gwanDae,
      '해': TwelveStage.geonRok,
      '자': TwelveStage.jeWang,
      '축': TwelveStage.쇠,
      '인': TwelveStage.byeong,
      '묘': TwelveStage.sa,
      '진': TwelveStage.myo,
      '사': TwelveStage.jeol,
      '오': TwelveStage.tae,
      '미': TwelveStage.yang,
    },
    '계': {
      '묘': TwelveStage.jangSaeng,
      '인': TwelveStage.mokYok,
      '축': TwelveStage.gwanDae,
      '자': TwelveStage.geonRok,
      '해': TwelveStage.jeWang,
      '술': TwelveStage.쇠,
      '유': TwelveStage.byeong,
      '신': TwelveStage.sa,
      '미': TwelveStage.myo,
      '오': TwelveStage.jeol,
      '사': TwelveStage.tae,
      '진': TwelveStage.yang,
    },
  };
  
  /// Get the Twelve Stage of a heavenly stem in an earthly branch
  /// 
  /// [gan] - Heavenly stem (천간)
  /// [ji] - Earthly branch (지지)
  /// 
  /// Returns the corresponding TwelveStage
  static TwelveStage? getTwelveStage(String gan, String ji) {
    return _stageTable[gan]?[ji];
  }
}
