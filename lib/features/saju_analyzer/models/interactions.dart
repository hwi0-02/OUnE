/// Interaction types between elements in Saju
enum InteractionType {
  /// 천간합 (Heavenly Stems Combination)
  cheonganHab,
  
  /// 천간충 (Heavenly Stems Clash)
  cheonganChung,
  
  /// 지지육합 (Six Earthly Branch Combinations)
  jijiYukHab,
  
  /// 지지삼합 (Three Harmony)
  jijiSamHab,
  
  /// 지지방합 (Directional Combination)
  jijiBangHab,
  
  /// 지지충 (Earthly Branch Clash)
  jijiChung,
  
  /// 지지형 (Punishment)
  jijiHyeong,
  
  /// 지지파 (Destruction)
  jijiPa,
  
  /// 지지해 (Harm)
  jijiHae,
}

/// Result of an interaction between two elements
class InteractionResult {
  final InteractionType type;
  final String element1;
  final String element2;
  final String? resultingElement; // For combinations that transform elements
  final String description;
  
  const InteractionResult({
    required this.type,
    required this.element1,
    required this.element2,
    this.resultingElement,
    required this.description,
  });
  
  @override
  String toString() {
    if (resultingElement != null) {
      return '$element1 + $element2 = $resultingElement (${type.name})';
    }
    return '$element1 ↔ $element2 (${type.name})';
  }
}

/// Calculator for element interactions (합충형파해)
class InteractionCalculator {
  /// 천간합 (Heavenly Stems Combinations)
  /// 5 pairs that combine to form new elements
  static const Map<String, Map<String, String>> _cheonganHab = {
    '갑': {'기': '토'}, // 갑기합토
    '기': {'갑': '토'},
    '을': {'경': '금'}, // 을경합금
    '경': {'을': '금'},
    '병': {'신': '수'}, // 병신합수
    '신': {'병': '수'},
    '정': {'임': '목'}, // 정임합목
    '임': {'정': '목'},
    '무': {'계': '화'}, // 무계합화
    '계': {'무': '화'},
  };
  
  /// 천간충 (Heavenly Stems Clashes)
  static const Map<String, String> _cheonganChung = {
    '갑': '경', '경': '갑',
    '을': '신', '신': '을',
    '병': '임', '임': '병',
    '정': '계', '계': '정',
    // 무, 기 (토) has no direct clash in standard theory
  };
  
  /// 지지육합 (Six Combinations)
  static const Map<String, Map<String, String>> _jijiYukHab = {
    '자': {'축': '토'}, // 자축합토
    '축': {'자': '토'},
    '인': {'해': '목'}, // 인해합목
    '해': {'인': '목'},
    '묘': {'술': '화'}, // 묘술합화
    '술': {'묘': '화'},
    '진': {'유': '금'}, // 진유합금
    '유': {'진': '금'},
    '사': {'신': '수'}, // 사신합수
    '신': {'사': '수'},
    '오': {'미': '토'}, // 오미합토 (일부 이론)
    '미': {'오': '토'},
  };
  
  /// 지지삼합 (Three Harmony) - Creates elemental bureaus
  static const List<Map<String, dynamic>> _jijiSamHab = [
    {'elements': ['신', '자', '진'], 'result': '수'}, // 신자진 수국
    {'elements': ['해', '묘', '미'], 'result': '목'}, // 해묘미 목국
    {'elements': ['인', '오', '술'], 'result': '화'}, // 인오술 화국
    {'elements': ['사', '유', '축'], 'result': '금'}, // 사유축 금국
  ];
  
  /// 지지방합 (Directional Combinations)
  static const List<Map<String, dynamic>> _jijiBangHab = [
    {'elements': ['인', '묘', '진'], 'result': '목', 'direction': '동방'}, // 동방목
    {'elements': ['사', '오', '미'], 'result': '화', 'direction': '남방'}, // 남방화
    {'elements': ['신', '유', '술'], 'result': '금', 'direction': '서방'}, // 서방금
    {'elements': ['해', '자', '축'], 'result': '수', 'direction': '북방'}, // 북방수
  ];
  
  /// 지지충 (Earthly Branch Clashes)
  static const Map<String, String> _jijiChung = {
    '자': '오', '오': '자',
    '축': '미', '미': '축',
    '인': '신', '신': '인',
    '묘': '유', '유': '묘',
    '진': '술', '술': '진',
    '사': '해', '해': '사',
  };
  
  /// 지지형 (Punishments)
  static const List<List<String>> _jijiHyeong = [
    ['인', '사', '신'], // 삼형살 (무은지형)
    ['축', '미', '술'], // 삼형살 (지세지형)
    ['자', '묘'], // 자형(무례지형)
  ];
  
  /// 지지파 (Destructions)
  static const Map<String, String> _jijiPa = {
    '자': '유', '유': '자',
    '오': '묘', '묘': '오',
    '인': '해', '해': '인',
    '사': '신', '신': '사',
  };
  
  /// 지지해 (Harms)
  static const Map<String, String> _jijiHae = {
    '자': '미', '미': '자',
    '축': '오', '오': '축',
    '인': '사', '사': '인',
    '묘': '진', '진': '묘',
    '신': '해', '해': '신',
    '유': '술', '술': '유',
  };
  
  /// Find all interactions in a Saju chart
  /// 
  /// [pillars] - Map of pillar positions to GanJi
  /// Example: {'year': '갑자', 'month': '병인', 'day': '무오', 'hour': '계해'}
  static List<InteractionResult> findAllInteractions(Map<String, String> pillars) {
    final results = <InteractionResult>[];
    
    // Extract all Gan and Ji
    final allGan = <String>[];
    final allJi = <String>[];
    
    for (var ganji in pillars.values) {
      if (ganji.length >= 2) {
        allGan.add(ganji.substring(0, 1));
        allJi.add(ganji.substring(1, 2));
      }
    }
    
    // Check Cheongan Hab
    for (int i = 0; i < allGan.length; i++) {
      for (int j = i + 1; j < allGan.length; j++) {
        final result = checkCheonganHab(allGan[i], allGan[j]);
        if (result != null) results.add(result);
        
        final clash = checkCheonganChung(allGan[i], allGan[j]);
        if (clash != null) results.add(clash);
      }
    }
    
    // Check Jiji interactions
    for (int i = 0; i < allJi.length; i++) {
      for (int j = i + 1; j < allJi.length; j++) {
        final hab = checkJijiYukHab(allJi[i], allJi[j]);
        if (hab != null) results.add(hab);
        
        final chung = checkJijiChung(allJi[i], allJi[j]);
        if (chung != null) results.add(chung);
        
        final pa = checkJijiPa(allJi[i], allJi[j]);
        if (pa != null) results.add(pa);
        
        final hae = checkJijiHae(allJi[i], allJi[j]);
        if (hae != null) results.add(hae);
      }
    }
    
    // Check SamHab (requires 3 elements)
    final samHabResults = checkJijiSamHab(allJi);
    results.addAll(samHabResults);
    
    // Check BangHab (requires 3 elements)
    final bangHabResults = checkJijiBangHab(allJi);
    results.addAll(bangHabResults);
    
    // Check Hyeong (punishment)
    final hyeongResults = checkJijiHyeong(allJi);
    results.addAll(hyeongResults);
    
    return results;
  }
  
  /// Check for Cheongan Hab (combination)
  static InteractionResult? checkCheonganHab(String gan1, String gan2) {
    final result = _cheonganHab[gan1]?[gan2];
    if (result != null) {
      return InteractionResult(
        type: InteractionType.cheonganHab,
        element1: gan1,
        element2: gan2,
        resultingElement: result,
        description: '$gan1$gan2 합 → $result로 변화',
      );
    }
    return null;
  }
  
  /// Check for Cheongan Chung (clash)
  static InteractionResult? checkCheonganChung(String gan1, String gan2) {
    if (_cheonganChung[gan1] == gan2) {
      return InteractionResult(
        type: InteractionType.cheonganChung,
        element1: gan1,
        element2: gan2,
        description: '$gan1$gan2 충 (충돌)',
      );
    }
    return null;
  }
  
  /// Check for Jiji Yuk Hab (six combinations)
  static InteractionResult? checkJijiYukHab(String ji1, String ji2) {
    final result = _jijiYukHab[ji1]?[ji2];
    if (result != null) {
      return InteractionResult(
        type: InteractionType.jijiYukHab,
        element1: ji1,
        element2: ji2,
        resultingElement: result,
        description: '$ji1$ji2 육합 → $result',
      );
    }
    return null;
  }
  
  /// Check for Jiji Sam Hab (three harmony)
  static List<InteractionResult> checkJijiSamHab(List<String> allJi) {
    final results = <InteractionResult>[];
    
    for (var config in _jijiSamHab) {
      final elements = config['elements'] as List<String>;
      final result = config['result'] as String;
      
      // Check if all three elements are present
      final hasAll = elements.every((e) => allJi.contains(e));
      if (hasAll) {
        results.add(InteractionResult(
          type: InteractionType.jijiSamHab,
          element1: elements.join(','),
          element2: '',
          resultingElement: result,
          description: '${elements.join('·')} 삼합 → $result국',
        ));
      }
    }
    
    return results;
  }
  
  /// Check for Jiji Bang Hab (directional combination)
  static List<InteractionResult> checkJijiBangHab(List<String> allJi) {
    final results = <InteractionResult>[];
    
    for (var config in _jijiBangHab) {
      final elements = config['elements'] as List<String>;
      final result = config['result'] as String;
      final direction = config['direction'] as String;
      
      final hasAll = elements.every((e) => allJi.contains(e));
      if (hasAll) {
        results.add(InteractionResult(
          type: InteractionType.jijiBangHab,
          element1: elements.join(','),
          element2: '',
          resultingElement: result,
          description: '${elements.join('·')} $direction 방합 → $result',
        ));
      }
    }
    
    return results;
  }
  
  /// Check for Jiji Chung (clash)
  static InteractionResult? checkJijiChung(String ji1, String ji2) {
    if (_jijiChung[ji1] == ji2) {
      return InteractionResult(
        type: InteractionType.jijiChung,
        element1: ji1,
        element2: ji2,
        description: '$ji1$ji2 충 (강한 충돌)',
      );
    }
    return null;
  }
  
  /// Check for Jiji Hyeong (punishment)
  static List<InteractionResult> checkJijiHyeong(List<String> allJi) {
    final results = <InteractionResult>[];
    
    for (var punishment in _jijiHyeong) {
      if (punishment.length == 3) {
        // Triple punishment
        final hasAll = punishment.every((e) => allJi.contains(e));
        if (hasAll) {
          results.add(InteractionResult(
            type: InteractionType.jijiHyeong,
            element1: punishment.join(','),
            element2: '',
            description: '${punishment.join('·')} 삼형 (형벌)',
          ));
        }
      } else if (punishment.length == 2) {
        // Double punishment
        final hasAll = punishment.every((e) => allJi.contains(e));
        if (hasAll) {
          results.add(InteractionResult(
            type: InteractionType.jijiHyeong,
            element1: punishment[0],
            element2: punishment[1],
            description: '${punishment.join('·')} 자형 (자기 형벌)',
          ));
        }
      }
    }
    
    return results;
  }
  
  /// Check for Jiji Pa (destruction)
  static InteractionResult? checkJijiPa(String ji1, String ji2) {
    if (_jijiPa[ji1] == ji2) {
      return InteractionResult(
        type: InteractionType.jijiPa,
        element1: ji1,
        element2: ji2,
        description: '$ji1$ji2 파 (파괴)',
      );
    }
    return null;
  }
  
  /// Check for Ji Ji Hae (harm)
  static InteractionResult? checkJijiHae(String ji1, String ji2) {
    if (_jijiHae[ji1] == ji2) {
      return InteractionResult(
        type: InteractionType.jijiHae,
        element1: ji1,
        element2: ji2,
        description: '$ji1$ji2 해 (해로움)',
      );
    }
    return null;
  }
}
