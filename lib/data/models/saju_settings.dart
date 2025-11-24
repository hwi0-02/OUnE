/// Saju calculation settings
class SajuSettings {
  /// Whether to apply Ya-Ja-Si (夜子時) logic
  /// 
  /// Ya-Ja-Si (23:00-23:59):
  /// - When true: 23:00-23:59 uses next day's date for hour pillar but keeps current day pillar
  /// - When false: Day changes at 23:00 (traditional method)
  final bool useYaJaSi;

  /// Local longitude for solar time correction
  /// Default: Seoul (126.9784°)
  final double? localLongitude;

  /// Whether to apply Equation of Time (EoT) correction
  /// 
  /// EoT accounts for Earth's elliptical orbit and axial tilt,
  /// adding ±16 minutes variation throughout the year.
  /// 
  /// When false, uses only longitude correction (simpler, usually sufficient)
  /// When true, applies additional EoT for maximum precision
  final bool useEquationOfTime;

  /// Whether to apply solar time correction (longitude-based)
  final bool useSolarTimeCorrection;

  const SajuSettings({
    this.useYaJaSi = false,
    this.localLongitude,
    this.useSolarTimeCorrection = true,
    this.useEquationOfTime = false,
  });

  SajuSettings copyWith({
    bool? useYaJaSi,
    double? localLongitude,
    bool? useSolarTimeCorrection,
    bool? useEquationOfTime,
  }) {
    return SajuSettings(
      useYaJaSi: useYaJaSi ?? this.useYaJaSi,
      localLongitude: localLongitude ?? this.localLongitude,
      useSolarTimeCorrection: useSolarTimeCorrection ?? this.useSolarTimeCorrection,
      useEquationOfTime: useEquationOfTime ?? this.useEquationOfTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useYaJaSi': useYaJaSi,
      'localLongitude': localLongitude,
      'useSolarTimeCorrection': useSolarTimeCorrection,
      'useEquationOfTime': useEquationOfTime,
    };
  }

  factory SajuSettings.fromJson(Map<String, dynamic> json) {
    return SajuSettings(
      useYaJaSi: json['useYaJaSi'] as bool? ?? false,
      localLongitude: json['localLongitude'] as double?,
      useSolarTimeCorrection: json['useSolarTimeCorrection'] as bool? ?? true,
      useEquationOfTime: json['useEquationOfTime'] as bool? ?? false,
    );
  }
}
