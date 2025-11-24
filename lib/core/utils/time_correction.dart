import 'package:app_project/core/utils/equation_of_time.dart';

/// Korean Time Zone History and Solar Time Correction Utilities
/// 
/// This class handles the complex history of Korean Standard Time changes
/// and provides accurate solar time corrections for Saju calculations.
class TimeCorrection {
  /// Korean Standard Time history data
  /// Format: start year -> (standard longitude, offset in minutes)
  static const Map<int, _TimeZoneInfo> _koreanTimeZoneHistory = {
    1908: _TimeZoneInfo(127.5, 0),   // Daehan Empire standard (1908-1911)
    1912: _TimeZoneInfo(135.0, -30), // Japanese occupation (1912-1953)
    1954: _TimeZoneInfo(127.5, 0),   // Korean independent standard (1954-1961)
    1961: _TimeZoneInfo(135.0, -30), // Current standard (1961-present)
  };

  /// 1988 Seoul Olympics Summer Time
  /// May 8 - October 9, 1988
  static final DateTime _summerTimeStart = DateTime(1988, 5, 8);
  static final DateTime _summerTimeEnd = DateTime(1988, 10, 9, 23, 59, 59);

  /// Major Korean cities longitude data
  static const Map<String, double> cityLongitudes = {
    'seoul': 126.9784,
    'busan': 129.0756,
    'incheon': 126.7052,
    'daegu': 128.6014,
    'daejeon': 127.3845,
    'gwangju': 126.8526,
    'ulsan': 129.3114,
    'sejong': 127.2890,
    'jeju': 126.5312,
  };

  /// Default longitude for Korea (Seoul)
  static const double defaultLongitude = 126.9784;

  /// Get the standard longitude for a given date
  static double getStandardLongitude(DateTime date) {
    if (date.year < 1908) {
      // Before standardization, use local solar time (no correction)
      return defaultLongitude;
    }

    // Find the applicable time zone info
    _TimeZoneInfo? info;
    int? applicableYear;
    
    for (var year in _koreanTimeZoneHistory.keys.toList()..sort()) {
      if (date.year >= year) {
        applicableYear = year;
        info = _koreanTimeZoneHistory[year];
      } else {
        break;
      }
    }

    return info?.standardLongitude ?? 135.0;
  }

  /// Calculate solar time correction in minutes
  /// 
  /// Takes into account:
  /// 1. Longitude difference (4 minutes per degree)
  /// 2. Historical Korean timezone changes
  /// 3. 1988 Summer Time
  /// 4. Equation of Time (optional, for maximum precision)
  /// 
  /// Returns: correction in minutes to add to clock time
  static int getSolarTimeCorrection(
    DateTime clockTime, {
    double? localLongitude,
    bool applyEquationOfTime = false,
  }) {
    final longitude = localLongitude ?? defaultLongitude;
    
    // 1. Get applicable standard longitude for this date
    final standardLon = getStandardLongitude(clockTime);
    
    // 2. Calculate longitude correction (4 minutes per degree)
    final longitudeCorrection = ((longitude - standardLon) * 4).round();
    
    // 3. Check for 1988 Summer Time
    int summerTimeCorrection = 0;
    if (clockTime.isAfter(_summerTimeStart) && 
        clockTime.isBefore(_summerTimeEnd)) {
      summerTimeCorrection = -60;
    }
    
    // 4. Apply Equation of Time if requested
    int eotCorrection = 0;
    if (applyEquationOfTime) {
      eotCorrection = EquationOfTime.calculate(clockTime).round();
    }
    
    return longitudeCorrection + summerTimeCorrection + eotCorrection;
  }

  /// Convert clock time to solar time
  /// 
  /// Example:
  /// - 2024-03-15 13:00 in Seoul
  /// - Standard: 135° (current era)
  /// - Seoul: 126.98°
  /// - Correction: (126.98 - 135) × 4 ≈ -32 minutes
  /// - EoT: ~-10 minutes (March)
  /// - Total: -42 minutes
  /// - Solar time: 12:18
  static DateTime toSolarTime(
    DateTime clockTime, {
    double? localLongitude,
    bool applyEquationOfTime = false,
  }) {
    final correction = getSolarTimeCorrection(
      clockTime,
      localLongitude: localLongitude,
      applyEquationOfTime: applyEquationOfTime,
    );
    
    return clockTime.add(Duration(minutes: correction));
  }

  /// Get detailed correction info for debugging/display
  static Map<String, dynamic> getCorrectionDetails(
    DateTime clockTime, {
    double? localLongitude,
    bool applyEquationOfTime = false,
  }) {
    final longitude = localLongitude ?? defaultLongitude;
    final standardLon = getStandardLongitude(clockTime);
    final longitudeCorrection = ((longitude - standardLon) * 4).round();
    
    int summerTimeCorrection = 0;
    bool isSummerTime = false;
    if (clockTime.isAfter(_summerTimeStart) && 
        clockTime.isBefore(_summerTimeEnd)) {
      summerTimeCorrection = -60;
      isSummerTime = true;
    }
    
    int eotCorrection = 0;
    if (applyEquationOfTime) {
      eotCorrection = EquationOfTime.calculate(clockTime).round();
    }
    
    final totalCorrection = longitudeCorrection + summerTimeCorrection + eotCorrection;
    final solarTime = clockTime.add(Duration(minutes: totalCorrection));
    
    return {
      'clockTime': clockTime,
      'solarTime': solarTime,
      'localLongitude': longitude,
      'standardLongitude': standardLon,
      'longitudeCorrection': longitudeCorrection,
      'summerTimeCorrection': summerTimeCorrection,
      'isSummerTime': isSummerTime,
      'equationOfTime': eotCorrection,
      'eotApplied': applyEquationOfTime,
      'totalCorrection': totalCorrection,
      'era': _getEraName(clockTime.year),
    };
  }

  /// Get the name of the timezone era
  static String _getEraName(int year) {
    if (year < 1908) return '표준시 이전 (지방시)';
    if (year < 1912) return '대한제국 표준시 (127.5°)';
    if (year < 1954) return '일제강점기 (135°)';
    if (year < 1961) return '독립 표준시 (127.5°)';
    return '현행 표준시 (135°)';
  }
}

/// Internal class to store timezone information
class _TimeZoneInfo {
  final double standardLongitude;
  final int offsetMinutes;
  
  const _TimeZoneInfo(this.standardLongitude, this.offsetMinutes);
}
