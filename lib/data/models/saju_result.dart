class SajuResult {
  final String yearGan;
  final String yearJi;
  final String monthGan;
  final String monthJi;
  final String dayGan;
  final String dayJi;
  final String hourGan;
  final String hourJi;

  final String yearOhaeng;
  final String monthOhaeng;
  final String dayOhaeng;
  final String hourOhaeng;

  final bool isSolarTermBoundary;
  final String? boundaryWarning;

  SajuResult({
    required this.yearGan,
    required this.yearJi,
    required this.monthGan,
    required this.monthJi,
    required this.dayGan,
    required this.dayJi,
    required this.hourGan,
    required this.hourJi,
    required this.yearOhaeng,
    required this.monthOhaeng,
    required this.dayOhaeng,
    required this.hourOhaeng,
    this.isSolarTermBoundary = false,
    this.boundaryWarning,
  });

  String get yearPillar => '$yearGan$yearJi';
  String get monthPillar => '$monthGan$monthJi';
  String get dayPillar => '$dayGan$dayJi';
  String get hourPillar => '$hourGan$hourJi';

  @override
  String toString() {
    return '사주팔자: $yearPillar $monthPillar $dayPillar $hourPillar';
  }
}
