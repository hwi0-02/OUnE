class DetailedFortuneModel {
  final String id;
  final String userId;
  final DateTime date;
  
  // Category scores (0-100)
  final int loveScore;
  final int moneyScore;
  final int workScore;
  final int healthScore;
  
  // Category content
  final String loveContent;
  final String moneyContent;
  final String workContent;
  final String healthContent;
  
  final DateTime createdAt;

  DetailedFortuneModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.loveScore,
    required this.moneyScore,
    required this.workScore,
    required this.healthScore,
    required this.loveContent,
    required this.moneyContent,
    required this.workContent,
    required this.healthContent,
    required this.createdAt,
  });

  factory DetailedFortuneModel.fromJson(Map<String, dynamic> json) {
    return DetailedFortuneModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['fortune_date']),
      loveScore: json['love_score'] ?? 0,
      moneyScore: json['money_score'] ?? 0,
      workScore: json['work_score'] ?? 0,
      healthScore: json['health_score'] ?? 0,
      loveContent: json['love_content'] ?? '',
      moneyContent: json['money_content'] ?? '',
      workContent: json['work_content'] ?? '',
      healthContent: json['health_content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'fortune_date': date.toIso8601String().split('T')[0],
      'love_score': loveScore,
      'money_score': moneyScore,
      'work_score': workScore,
      'health_score': healthScore,
      'love_content': loveContent,
      'money_content': moneyContent,
      'work_content': workContent,
      'health_content': healthContent,
    };
  }
}
