class FortuneModel {
  final String id;
  final String userId;
  final DateTime date;
  final int totalScore;
  final String content; // JSON string or simple text for now
  final String luckyColor;
  final int luckyNumber;

  FortuneModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalScore,
    required this.content,
    required this.luckyColor,
    required this.luckyNumber,
  });

  factory FortuneModel.fromJson(Map<String, dynamic> json) {
    return FortuneModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      date: DateTime.parse(json['fortune_date']),
      totalScore: json['score'] ?? 0,
      content: json['content'].toString(),
      luckyColor: json['lucky_color'] ?? 'Red',
      luckyNumber: json['lucky_number'] ?? 7,
    );
  }
}
