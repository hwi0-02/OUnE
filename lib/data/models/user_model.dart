import 'package:app_project/features/saju_analyzer/logic/daeun_calculator.dart';

class UserModel {
  final String id;
  final DateTime createdAt;
  final String? nickname;
  final DateTime birthDate;
  final String? birthTime; // 'HH:mm' format
  final String? gender;
  final bool isLunar;
  final String? authProvider;

  UserModel({
    required this.id,
    required this.createdAt,
    this.nickname,
    required this.birthDate,
    this.birthTime,
    this.gender,
    this.isLunar = false,
    this.authProvider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      nickname: json['nickname'],
      birthDate: DateTime.parse(json['birth_date']),
      birthTime: json['birth_time'],
      gender: json['gender'],
      isLunar: json['is_lunar'] ?? false,
      authProvider: json['auth_provider'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'nickname': nickname,
      'birth_date': birthDate.toIso8601String(),
      'birth_time': birthTime,
      'gender': gender,
      'is_lunar': isLunar,
      'auth_provider': authProvider,
    };
  }

  /// Get complete birth DateTime (combines birthDate and birthTime)
  DateTime get completeBirthDateTime {
    if (birthTime != null) {
      final parts = birthTime!.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        return DateTime(
          birthDate.year,
          birthDate.month,
          birthDate.day,
          hour,
          minute,
        );
      }
    }
    // Default to noon if no birthTime specified
    return DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      12,
      0,
    );
  }

  /// Get Gender enum for Saju analysis
  Gender? get genderEnum {
    if (gender == null) return null;
    switch (gender!.toLowerCase()) {
      case 'male':
      case '남':
      case '남성':
        return Gender.male;
      case 'female':
      case '여':
      case '여성':
        return Gender.female;
      default:
        return null;
    }
  }

  /// Check if user has complete Saju data
  bool get hasCompleteSajuData {
    return birthTime != null && gender != null;
  }
}
