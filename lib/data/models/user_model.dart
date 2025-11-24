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
}
