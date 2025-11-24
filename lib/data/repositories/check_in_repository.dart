import 'package:app_project/data/models/check_in_model.dart';
import 'package:app_project/data/repositories/wallet_repository.dart';
import 'package:app_project/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckInRepository {
  final SupabaseClient _supabase = SupabaseService().client;
  final WalletRepository _walletRepository = WalletRepository();

  /// Get user's check-in history for current month
  Future<List<CheckInModel>> getCheckInHistory(String userId, DateTime month) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final response = await _supabase
          .from('check_ins')
          .select()
          .eq('user_id', userId)
          .gte('check_in_date', startOfMonth.toIso8601String().split('T')[0])
          .lte('check_in_date', endOfMonth.toIso8601String().split('T')[0])
          .order('check_in_date', ascending: true);

      return (response as List).map((json) => CheckInModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get check-in history: $e');
    }
  }

  /// Get today's check-in if exists
  Future<CheckInModel?> getTodayCheckIn(String userId) async {
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final response = await _supabase
          .from('check_ins')
          .select()
          .eq('user_id', userId)
          .eq('check_in_date', todayStr)
          .maybeSingle();

      if (response != null) {
        return CheckInModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get today check-in: $e');
    }
  }

  /// Perform check-in and calculate streak
  Future<CheckInModel> performCheckIn(String userId) async {
    try {
      // Check if already checked in today
      final todayCheckIn = await getTodayCheckIn(userId);
      if (todayCheckIn != null) {
        throw Exception('Already checked in today');
      }

      // Get yesterday's check-in to calculate streak
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

      final yesterdayCheckIn = await _supabase
          .from('check_ins')
          .select()
          .eq('user_id', userId)
          .eq('check_in_date', yesterdayStr)
          .maybeSingle();

      int streak = 1;
      if (yesterdayCheckIn != null) {
        final yesterdayModel = CheckInModel.fromJson(yesterdayCheckIn);
        streak = yesterdayModel.streak + 1;
      }

      // Calculate reward based on streak
      int reward = _calculateReward(streak);

      // Create check-in record
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final checkIn = await _supabase
          .from('check_ins')
          .insert({
            'user_id': userId,
            'check_in_date': todayStr,
            'streak': streak,
            'reward_amount': reward,
          })
          .select()
          .single();

      // Add coins to wallet
      await _walletRepository.addCoins(userId, reward);

      return CheckInModel.fromJson(checkIn);
    } catch (e) {
      throw Exception('Failed to perform check-in: $e');
    }
  }

  /// Calculate reward based on streak
  int _calculateReward(int streak) {
    if (streak >= 30) {
      return 30; // 30일 연속: 30개 (+ 특별 배경화면은 별도 처리)
    } else if (streak >= 7) {
      return 10; // 7일 연속: 10개
    } else if (streak >= 3) {
      return 3; // 3일 연속: 3개
    } else {
      return 1; // 기본: 1개
    }
  }

  /// Get current streak
  Future<int> getCurrentStreak(String userId) async {
    try {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      
      // Check today first
      final todayCheckIn = await getTodayCheckIn(userId);
      if (todayCheckIn != null) {
        return todayCheckIn.streak;
      }

      // Check yesterday
      final yesterdayStr = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      final yesterdayCheckIn = await _supabase
          .from('check_ins')
          .select()
          .eq('user_id', userId)
          .eq('check_in_date', yesterdayStr)
          .maybeSingle();

      if (yesterdayCheckIn != null) {
        final model = CheckInModel.fromJson(yesterdayCheckIn);
        return model.streak;
      }

      return 0; // Streak broken
    } catch (e) {
      return 0;
    }
  }
}
