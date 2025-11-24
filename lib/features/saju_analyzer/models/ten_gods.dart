/// Ten Gods (십성/육친)
/// 
/// Represents the relationship between the Day Master (일간) and other elements
/// in the Four Pillars, based on the Five Elements generation and control cycles.
enum TenGod {
  /// 비견 (比肩) - Same element, same yin/yang
  /// Represents siblings, competitors, equals
  biGyeon,
  
  /// 겁재 (劫財) - Same element, opposite yin/yang
  /// Represents competitors for resources, challenges
  geopJae,
  
  /// 식신 (食神) - I generate, same yin/yang
  /// Represents creativity, talents, children
  sikSin,
  
  /// 상관 (傷官) - I generate, opposite yin/yang
  /// Represents expression, intelligence, rebellion
  sangGwan,
  
  /// 편재 (偏財) - I control, opposite yin/yang
  /// Represents money, father, material wealth
  pyeonJae,
  
  /// 정재 (正財) - I control, same yin/yang
  /// Represents stable income, wife (for men), property
  jeongJae,
  
  /// 편관 (偏官/七殺) - Controls me, opposite yin/yang
  /// Represents authority, pressure, challenges
  pyeonGwan,
  
  /// 정관 (正官) - Controls me, same yin/yang
  /// Represents official position, husband (for women), law
  jeongGwan,
  
  /// 편인 (偏印/梟神) - Generates me, opposite yin/yang
  /// Represents unconventional learning, mother's care
  pyeonIn,
  
  /// 정인 (正印) - Generates me, same yin/yang
  /// Represents education, credentials, nurturing
  jeongIn,
}

/// Extension methods for TenGod
extension TenGodExtension on TenGod {
  /// Get Korean name
  String get koreanName {
    switch (this) {
      case TenGod.biGyeon:
        return '비견';
      case TenGod.geopJae:
        return '겁재';
      case TenGod.sikSin:
        return '식신';
      case TenGod.sangGwan:
        return '상관';
      case TenGod.pyeonJae:
        return '편재';
      case TenGod.jeongJae:
        return '정재';
      case TenGod.pyeonGwan:
        return '편관';
      case TenGod.jeongGwan:
        return '정관';
      case TenGod.pyeonIn:
        return '편인';
      case TenGod.jeongIn:
        return '정인';
    }
  }
  
  /// Get description
  String get description {
    switch (this) {
      case TenGod.biGyeon:
        return '형제, 동료, 경쟁자';
      case TenGod.geopJae:
        return '재물의 경쟁, 도전';
      case TenGod.sikSin:
        return '창의성, 재능, 자식';
      case TenGod.sangGwan:
        return '표현력, 지성, 반항';
      case TenGod.pyeonJae:
        return '돈, 아버지, 물질';
      case TenGod.jeongJae:
        return '안정 수입, 아내, 재산';
      case TenGod.pyeonGwan:
        return '권위, 압력, 도전';
      case TenGod.jeongGwan:
        return '관직, 남편, 법';
      case TenGod.pyeonIn:
        return '비전통 학습, 모성';
      case TenGod.jeongIn:
        return '교육, 자격, 양육';
    }
  }
  
  /// Get category (비겁/식상/재성/관성/인성)
  String get category {
    switch (this) {
      case TenGod.biGyeon:
      case TenGod.geopJae:
        return '비겁';
      case TenGod.sikSin:
      case TenGod.sangGwan:
        return '식상';
      case TenGod.pyeonJae:
      case TenGod.jeongJae:
        return '재성';
      case TenGod.pyeonGwan:
      case TenGod.jeongGwan:
        return '관성';
      case TenGod.pyeonIn:
      case TenGod.jeongIn:
        return '인성';
    }
  }
}

/// Helper class to calculate Ten Gods
class TenGodCalculator {
  /// Calculate Ten God relationship between Day Master and target
  /// 
  /// [dayGan] - Day Master (일간)
  /// [targetGan] - Target heavenly stem to analyze
  /// 
  /// Returns the Ten God relationship
  static TenGod getTenGod(String dayGan, String targetGan) {
    // Get five elements
    final dayElement = _getElement(dayGan);
    final targetElement = _getElement(targetGan);
    
    // Get yin/yang
    final dayYinYang = _getYinYang(dayGan);
    final targetYinYang = _getYinYang(targetGan);
    
    final sameYinYang = dayYinYang == targetYinYang;
    
    // Determine relationship based on Five Elements cycle
    final relationship = _getElementRelationship(dayElement, targetElement);
    
    switch (relationship) {
      case 'same':
        return sameYinYang ? TenGod.biGyeon : TenGod.geopJae;
      case 'generate':
        return sameYinYang ? TenGod.sikSin : TenGod.sangGwan;
      case 'control':
        return sameYinYang ? TenGod.jeongJae : TenGod.pyeonJae;
      case 'controlled':
        return sameYinYang ? TenGod.jeongGwan : TenGod.pyeonGwan;
      case 'generated':
        return sameYinYang ? TenGod.jeongIn : TenGod.pyeonIn;
      default:
        // Log error and return default to prevent crash
        print('Error: Invalid relationship: $relationship (Day: $dayGan, Target: $targetGan)');
        return TenGod.biGyeon; // Default fallback
    }
  }
  
  /// Get element from heavenly stem
  static String _getElement(String gan) {
    const elementMap = {
      '갑': '목', '을': '목',
      '병': '화', '정': '화',
      '무': '토', '기': '토',
      '경': '금', '신': '금',
      '임': '수', '계': '수',
    };
    return elementMap[gan] ?? '';
  }
  
  /// Get yin/yang from heavenly stem
  static String _getYinYang(String gan) {
    const yangGans = ['갑', '병', '무', '경', '임'];
    return yangGans.contains(gan) ? '양' : '음';
  }
  
  /// Get relationship between two elements
  /// Returns: 'same', 'generate', 'control', 'controlled', 'generated'
  static String _getElementRelationship(String from, String to) {
    if (from == to) return 'same';
    
    // Generation cycle: 목 -> 화 -> 토 -> 금 -> 수 -> 목
    const generationCycle = {
      '목': '화',
      '화': '토',
      '토': '금',
      '금': '수',
      '수': '목',
    };
    
    // Control cycle: 목 -> 토, 화 -> 금, 토 -> 수, 금 -> 목, 수 -> 화
    const controlCycle = {
      '목': '토',
      '화': '금',
      '토': '수',
      '금': '목',
      '수': '화',
    };
    
    if (generationCycle[from] == to) return 'generate';
    if (controlCycle[from] == to) return 'control';
    
    // Check if "to" generates "from"
    if (generationCycle[to] == from) return 'generated';
    
    // Check if "to" controls "from"
    if (controlCycle[to] == from) return 'controlled';
    
    return 'unknown';
  }
}
