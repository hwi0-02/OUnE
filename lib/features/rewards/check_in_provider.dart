import 'package:app_project/data/models/check_in_model.dart';
import 'package:app_project/data/models/wallet_model.dart';
import 'package:app_project/data/repositories/check_in_repository.dart';
import 'package:app_project/data/repositories/wallet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Providers
final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return CheckInRepository();
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository();
});

// Wallet Provider
final walletProvider = FutureProvider.family<WalletModel, String>((ref, userId) async {
  final repository = ref.watch(walletRepositoryProvider);
  return await repository.getWallet(userId);
});

// Current Streak Provider
final currentStreakProvider = FutureProvider.family<int, String>((ref, userId) async {
  final repository = ref.watch(checkInRepositoryProvider);
  return await repository.getCurrentStreak(userId);
});

// Check-in History Provider (for current month)
final checkInHistoryProvider = FutureProvider.family<List<CheckInModel>, String>((ref, userId) async {
  final repository = ref.watch(checkInRepositoryProvider);
  return await repository.getCheckInHistory(userId, DateTime.now());
});

// Today's Check-in Provider
final todayCheckInProvider = FutureProvider.family<CheckInModel?, String>((ref, userId) async {
  final repository = ref.watch(checkInRepositoryProvider);
  return await repository.getTodayCheckIn(userId);
});

// Check-in Action Notifier
class CheckInNotifier extends StateNotifier<AsyncValue<CheckInModel?>> {
  final CheckInRepository _repository;
  final Ref _ref;

  CheckInNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> performCheckIn(String userId) async {
    state = const AsyncValue.loading();
    try {
      final checkIn = await _repository.performCheckIn(userId);
      state = AsyncValue.data(checkIn);
      
      // Refresh other providers
      _ref.invalidate(walletProvider);
      _ref.invalidate(currentStreakProvider);
      _ref.invalidate(checkInHistoryProvider);
      _ref.invalidate(todayCheckInProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final checkInNotifierProvider = StateNotifierProvider.autoDispose<CheckInNotifier, AsyncValue<CheckInModel?>>((ref) {
  return CheckInNotifier(ref.watch(checkInRepositoryProvider), ref);
});
