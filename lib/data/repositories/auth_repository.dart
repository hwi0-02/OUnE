import 'package:app_project/data/models/user_model.dart';
import 'package:app_project/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = SupabaseService().client;

  Future<AuthResponse> signInAnonymously() async {
    return await _client.auth.signInAnonymously();
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> createUserProfile({
    required String userId,
    required DateTime birthDate,
    String? birthTime,
    String? gender,
    String? nickname,
    bool isLunar = false,
  }) async {
    await _client.from('users').insert({
      'id': userId,
      'birth_date': birthDate.toIso8601String(),
      'birth_time': birthTime,
      'gender': gender,
      'nickname': nickname,
      'is_lunar': isLunar,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  User? get currentUser => _client.auth.currentUser;
}
