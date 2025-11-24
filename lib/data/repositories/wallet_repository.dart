import 'package:app_project/data/models/wallet_model.dart';
import 'package:app_project/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalletRepository {
  final SupabaseClient _supabase = SupabaseService().client;

  /// Get or create wallet for user
  Future<WalletModel> getWallet(String userId) async {
    try {
      final response = await _supabase
          .from('wallets')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        return WalletModel.fromJson(response);
      }

      // Create new wallet with initial balance
      final newWallet = await _supabase
          .from('wallets')
          .insert({
            'user_id': userId,
            'balance': 0,
          })
          .select()
          .single();

      return WalletModel.fromJson(newWallet);
    } catch (e) {
      throw Exception('Failed to get wallet: $e');
    }
  }

  /// Add coins to wallet
  Future<WalletModel> addCoins(String userId, int amount) async {
    try {
      final wallet = await getWallet(userId);
      final newBalance = wallet.balance + amount;

      final updated = await _supabase
          .from('wallets')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return WalletModel.fromJson(updated);
    } catch (e) {
      throw Exception('Failed to add coins: $e');
    }
  }

  /// Deduct coins from wallet
  Future<WalletModel> deductCoins(String userId, int amount) async {
    try {
      final wallet = await getWallet(userId);
      
      if (wallet.balance < amount) {
        throw Exception('Insufficient balance');
      }

      final newBalance = wallet.balance - amount;

      final updated = await _supabase
          .from('wallets')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return WalletModel.fromJson(updated);
    } catch (e) {
      throw Exception('Failed to deduct coins: $e');
    }
  }
}
