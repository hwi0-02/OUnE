import 'package:app_project/data/models/user_model.dart';
import 'package:app_project/features/saju_analyzer/logic/daeun_calculator.dart';
import 'package:app_project/features/saju_analyzer/saju_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for cached Saju analysis
/// 
/// Automatically updates when user data changes
final sajuAnalysisProvider = StateNotifierProvider<SajuAnalysisNotifier, AsyncValue<SajuAnalysis?>>((ref) {
  return SajuAnalysisNotifier();
});

class SajuAnalysisNotifier extends StateNotifier<AsyncValue<SajuAnalysis?>> {
  SajuAnalysisNotifier() : super(const AsyncValue.data(null));
  
  /// Analyze user's Saju
  Future<void> analyzeUser(UserModel user) async {
    if (!user.hasCompleteSajuData) {
      state = const AsyncValue.data(null);
      return;
    }
    
    try {
      state = const AsyncValue.loading();
      
      final analysis = SajuService.analyzeSaju(
        birthDate: user.completeBirthDateTime,
        gender: user.genderEnum!,
      );
      
      state = AsyncValue.data(analysis);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Clear analysis
  void clear() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for daily fortune score
/// 
/// Calculates fortune for a specific date based on user's Saju
final dailyFortuneProvider = Provider.family<int?, DateTime>((ref, date) {
  final analysisAsync = ref.watch(sajuAnalysisProvider);
  
  return analysisAsync.when(
    data: (analysis) {
      if (analysis == null) return null;
      return SajuService.calculateDailyFortune(
        analysis: analysis,
        date: date,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider to get current Daeun period
final currentDaeunProvider = Provider<DaeunPeriod?>((ref) {
  final analysisAsync = ref.watch(sajuAnalysisProvider);
  final now = DateTime.now();
  
  return analysisAsync.when(
    data: (analysis) {
      if (analysis == null || analysis.daeunPeriods.isEmpty) return null;
      
      // Get birth year from first Daeun period's start year
      final firstPeriod = analysis.daeunPeriods.first;
      final birthYear = now.year - firstPeriod.startAge + 1;
      
      // Calculate current age (Korean age: current year - birth year + 1)
      final currentAge = now.year - birthYear + 1;
      
      // Find the Daeun period that contains current age
      for (var period in analysis.daeunPeriods) {
        if (currentAge >= period.startAge && currentAge <= period.endAge) {
          return period;
        }
      }
      
      // If not found, return null
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
