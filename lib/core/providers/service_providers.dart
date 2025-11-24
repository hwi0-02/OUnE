import 'package:app_project/data/repositories/auth_repository.dart';
import 'package:app_project/data/repositories/check_in_repository.dart';
import 'package:app_project/data/repositories/wallet_repository.dart';
import 'package:app_project/data/services/fortune_service.dart';
import 'package:app_project/data/services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
final supabaseServiceProvider = Provider<SupabaseService>((ref) => SupabaseService());
final fortuneServiceProvider = Provider<FortuneService>((ref) => FortuneService());

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
final walletRepositoryProvider = Provider<WalletRepository>((ref) => WalletRepository());
final checkInRepositoryProvider = Provider<CheckInRepository>((ref) => CheckInRepository());
