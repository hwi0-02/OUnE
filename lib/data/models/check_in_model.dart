class CheckInModel {
  final String id;
  final String userId;
  final DateTime checkInDate;
  final int streak; // 연속 출석 일수
  final int rewardAmount; // 지급된 솜사탕 개수
  final DateTime createdAt;

  CheckInModel({
    required this.id,
    required this.userId,
    required this.checkInDate,
    required this.streak,
    required this.rewardAmount,
    required this.createdAt,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      id: json['id'],
      userId: json['user_id'],
      checkInDate: DateTime.parse(json['check_in_date']),
      streak: json['streak'] ?? 1,
      rewardAmount: json['reward_amount'] ?? 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'check_in_date': checkInDate.toIso8601String().split('T')[0], // Date only
      'streak': streak,
      'reward_amount': rewardAmount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
