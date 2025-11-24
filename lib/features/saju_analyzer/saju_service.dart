import 'package:app_project/core/utils/saju_engine.dart';
import 'package:app_project/features/saju_analyzer/logic/daeun_calculator.dart';
import 'package:app_project/features/saju_analyzer/models/interactions.dart';
import 'package:app_project/features/saju_analyzer/models/ten_gods.dart';
import 'package:app_project/features/saju_analyzer/models/twelve_stages.dart';

/// Comprehensive Saju analysis result
class SajuAnalysis {
  final Map<String, String> pillars;
  final String dayGan;
  final String dayJi;
  final Gender gender;
  
  final Map<String, TenGod> tenGods;
  final Map<String, TwelveStage?> twelveStages;
  final List<InteractionResult> interactions;
  final List<DaeunPeriod> daeunPeriods;
  
  final Map<String, int> elementScores;
  final bool isStrong; // 신강 or 신약
  final String luckyElement; // 용신
  
  const SajuAnalysis({
    required this.pillars,
    required this.dayGan,
    required this.dayJi,
    required this.gender,
    required this.tenGods,
    required this.twelveStages,
    required this.interactions,
    required this.daeunPeriods,
    required this.elementScores,
    required this.isStrong,
    required this.luckyElement,
  });
}

/// Saju Analysis Service - Facade for all Saju interpretation features
class SajuService {
  /// Perform complete Saju analysis
  /// 
  /// [birthDate] - Birth date and time
  /// [gender] - Gender (required for Daeun calculation)
  /// 
  /// Returns comprehensive analysis result
  static SajuAnalysis analyzeSaju({
    required DateTime birthDate,
    required Gender gender,
  }) {
    // 1. Get basic four pillars
    final saju = SajuEngine.getSaju(birthDate);
    final dayGanJi = saju['day']!;
    final dayGan = dayGanJi.substring(0, 1);
    final dayJi = dayGanJi.substring(1, 2);
    
    // 2. Calculate Ten Gods for all pillars
    final tenGods = <String, TenGod>{};
    for (var entry in saju.entries) {
      if (entry.key != 'day') {
        final targetGan = entry.value.substring(0, 1);
        tenGods[entry.key] = TenGodCalculator.getTenGod(dayGan, targetGan);
      }
    }
    
    // 3. Calculate Twelve Stages
    final twelveStages = <String, TwelveStage?>{};
    for (var entry in saju.entries) {
      final gan = entry.value.substring(0, 1);
      final ji = entry.value.substring(1, 2);
      twelveStages[entry.key] = TwelveStageCalculator.getTwelveStage(gan, ji);
    }
    
    // 4. Find all interactions
    final interactions = InteractionCalculator.findAllInteractions(saju);
    
    // 5. Calculate Daeun
    final daeunPeriods = DaeunCalculator.calculateDaeunPeriods(
      birthDate: birthDate,
      gender: gender,
      monthGanJi: saju['month']!,
      maxAge: 100,
    );
    
    // 6. Calculate element scores and determine strength
    final elementScores = _calculateElementScores(saju, twelveStages);
    final isStrong = _isStrongChart(elementScores, dayGan);
    
    // 7. Determine lucky element (용신)
    final luckyElement = _determineLuckyElement(isStrong, elementScores, dayGan);
    
    return SajuAnalysis(
      pillars: saju,
      dayGan: dayGan,
      dayJi: dayJi,
      gender: gender,
      tenGods: tenGods,
      twelveStages: twelveStages,
      interactions: interactions,
      daeunPeriods: daeunPeriods,
      elementScores: elementScores,
      isStrong: isStrong,
      luckyElement: luckyElement,
    );
  }
  
  /// Calculate today's fortune score based on Saju analysis
  /// 
  /// [analysis] - Complete Saju analysis
  /// [date] - Date to calculate fortune for (default: today)
  /// 
  /// Returns score 0-100
  static int calculateDailyFortune({
    required SajuAnalysis analysis,
    DateTime? date,
  }) {
    date ??= DateTime.now();
    
    // Get today's GanJi
    final todayGanJi = SajuEngine.getDayGanJi(date);
    final todayGan = todayGanJi.substring(0, 1);
    final todayJi = todayGanJi.substring(1, 2);
    
    // Get today's element
    final todayGanElement = SajuEngine.getOhaeng(todayGan);
    final todayJiElement = SajuEngine.jijiOhaeng[todayJi] ?? '';
    
    int score = 50; // Base score
    
    // Check if today's element matches lucky element
    if (todayGanElement == analysis.luckyElement) {
      score += 30;
    }
    if (todayJiElement == analysis.luckyElement) {
      score += 20;
    }
    
    // Check Ten God relationship with today
    final todayTenGod = TenGodCalculator.getTenGod(analysis.dayGan, todayGan);
    
    // Favorable Ten Gods
    if (analysis.isStrong) {
      // 신강: 식상/재성/관성 favorable
      if ([TenGod.sikSin, TenGod.sangGwan].contains(todayTenGod)) {
        score += 15;
      }
      if ([TenGod.pyeonJae, TenGod.jeongJae].contains(todayTenGod)) {
        score += 10;
      }
      if ([TenGod.pyeonGwan, TenGod.jeongGwan].contains(todayTenGod)) {
        score += 5;
      }
    } else {
      // 신약: 인성/비겁 favorable
      if ([TenGod.pyeonIn, TenGod.jeongIn].contains(todayTenGod)) {
        score += 15;
      }
      if ([TenGod.biGyeon, TenGod.geopJae].contains(todayTenGod)) {
        score += 10;
      }
    }
    
    // Check for clashes with birth chart
    int clashPenalty = 0;
    for (var pillarGanJi in analysis.pillars.values) {
      final pillarJi = pillarGanJi.substring(1, 2);
      if (InteractionCalculator.checkJijiChung(todayJi, pillarJi) != null) {
        clashPenalty += 10;
      }
    }
    score -= clashPenalty;
    
    // Ensure score is between 0 and 100
    return score.clamp(0, 100);
  }
  
  /// Calculate element scores for the chart
  static Map<String, int> _calculateElementScores(
    Map<String, String> saju,
    Map<String, TwelveStage?> twelveStages,
  ) {
    final scores = {
      '목': 0,
      '화': 0,
      '토': 0,
      '금': 0,
      '수': 0,
    };
    
    // Weight by position
    const weights = {
      'year': 15,
      'month': 30,  // Month is most important
      'day': 20,
      'hour': 15,
    };
    
    for (var entry in saju.entries) {
      final position = entry.key;
      final ganJi = entry.value;
      final gan = ganJi.substring(0, 1);
      final ji = ganJi.substring(1, 2);
      
      final weight = weights[position] ?? 10;
      
      // Add scores for Gan
      final ganElement = SajuEngine.getOhaeng(gan);
      scores[ganElement] = (scores[ganElement] ?? 0) + weight;
      
      // Add scores for Ji
      final jiElement = SajuEngine.jijiOhaeng[ji];
      if (jiElement != null) {
        scores[jiElement] = (scores[jiElement] ?? 0) + (weight * 0.8).round();
      }
      
      // Bonus for strong Twelve Stage
      final stage = twelveStages[position];
      if (stage != null && stage.strengthScore >= 7) {
        scores[ganElement] = (scores[ganElement] ?? 0) + 5;
      }
    }
    
    return scores;
  }
  
  /// Determine if the chart is strong (신강) or weak (신약)
  static bool _isStrongChart(Map<String, int> elementScores, String dayGan) {
    final dayElement = SajuEngine.getOhaeng(dayGan);
    
    // Calculate supporting vs draining forces
    int supportingScore = 0;
    int drainingScore = 0;
    
    // Supporting: same element + generating element
    supportingScore += elementScores[dayElement] ?? 0;
    
    // Element that generates day element
    const generationCycle = {
      '목': '수',
      '화': '목',
      '토': '화',
      '금': '토',
      '수': '금',
    };
    final generatingElement = generationCycle[dayElement];
    if (generatingElement != null) {
      supportingScore += (elementScores[generatingElement] ?? 0);
    }
    
    // Draining: elements controlled by day element, elements that control day
    for (var entry in elementScores.entries) {
      if (entry.key != dayElement && entry.key != generatingElement) {
        drainingScore += entry.value;
      }
    }
    
    // Strong if supporting > draining
    return supportingScore > drainingScore;
  }
  
  /// Determine lucky element (용신)
  static String _determineLuckyElement(
    bool isStrong,
    Map<String, int> elementScores,
    String dayGan,
  ) {
    final dayElement = SajuEngine.getOhaeng(dayGan);
    
    if (isStrong) {
      // 신강: Need draining elements
      // Priority: Element I generate > Element that controls me
      const generationCycle = {
        '목': '화',
        '화': '토',
        '토': '금',
        '금': '수',
        '수': '목',
      };
      return generationCycle[dayElement] ?? dayElement;
    } else {
      // 신약: Need supporting elements
      // Priority: Element that generates me
      const reverseGeneration = {
        '목': '수',
        '화': '목',
        '토': '화',
        '금': '토',
        '수': '금',
      };
      return reverseGeneration[dayElement] ?? dayElement;
    }
  }
}
