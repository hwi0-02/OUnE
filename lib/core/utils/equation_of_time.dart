import 'dart:math' as math;

/// Equation of Time (EoT) Calculator
/// 
/// The Equation of Time represents the difference between apparent solar time
/// (sundial time) and mean solar time (clock time) due to:
/// 1. Earth's elliptical orbit around the Sun
/// 2. The tilt of Earth's axis (obliquity)
/// 
/// EoT varies throughout the year from approximately -14 to +16 minutes.
class EquationOfTime {
  /// Calculate Equation of Time for a given date
  /// 
  /// Returns the correction in minutes to be added to mean solar time
  /// to get apparent solar time.
  /// 
  /// Positive values: Sun is ahead (sundial shows later time than clock)
  /// Negative values: Sun is behind (sundial shows earlier time than clock)
  /// 
  /// Based on simplified formula from Jean Meeus
  static double calculate(DateTime date) {
    // Calculate day of year (1-365/366)
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    
    // Use more accurate formula based on orbital mechanics
    return calculateAccurate(date);
  }
  
  /// Accurate EoT calculation using orbital parameters
  /// 
  /// Based on equations from Astronomical Algorithms by Jean Meeus
  static double calculateAccurate(DateTime date) {
    // Calculate fractional year in radians
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final daysInYear = _isLeapYear(date.year) ? 366 : 365;
    final gamma = 2 * math.pi * (dayOfYear - 1) / daysInYear;
    
    // EoT components in minutes
    // These coefficients are derived from Earth's orbital parameters
    final eot = 229.18 * (
      0.000075 +
      0.001868 * math.cos(gamma) -
      0.032077 * math.sin(gamma) -
      0.014615 * math.cos(2 * gamma) -
      0.040849 * math.sin(2 * gamma)
    );
    
    return eot;
  }
  
  /// Simplified EoT using sinusoidal approximation
  /// 
  /// Less accurate but faster calculation suitable for most purposes
  static double calculateSimple(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    
    // Two main components of EoT
    // Component 1: Earth's elliptical orbit (peaks around Jan 4 and July 4)
    final eccentricity = 7.5 * math.sin(2 * math.pi * (dayOfYear - 4) / 365);
    
    // Component 2: Earth's axial tilt (peaks around May 15 and Nov 3)
    final obliquity = 9.9 * math.sin(4 * math.pi * (dayOfYear - 81) / 365);
    
    return eccentricity + obliquity;
  }
  
  /// Get EoT correction for each month (approximate midpoint values)
  /// 
  /// Useful for quick lookup without calculation
  static const Map<int, double> monthlyAverages = {
    1: -3.5,   // January: ~-3 to -14 minutes
    2: -13.9,  // February: peak negative
    3: -10.0,  // March
    4: -1.0,   // April: near zero
    5: 3.5,    // May: positive
    6: 2.0,    // June
    7: -4.0,   // July
    8: -6.0,   // August
    9: 0.0,    // September: near zero
    10: 11.0,  // October: positive
    11: 16.0,  // November: peak positive
    12: 3.0,   // December
  };
  
  /// Get approximate EoT from monthly table
  static double fromMonthlyTable(DateTime date) {
    return monthlyAverages[date.month] ?? 0.0;
  }
  
  /// Apply EoT correction to a time
  /// 
  /// Returns the solar time after applying the correction
  static DateTime applyCorrectionToMeanTime(DateTime meanTime) {
    final eot = calculate(meanTime);
    return meanTime.add(Duration(minutes: eot.round()));
  }
  
  /// Get detailed EoT information for a date
  static Map<String, dynamic> getDetails(DateTime date) {
    final accurate = calculateAccurate(date);
    final simple = calculateSimple(date);
    final monthly = fromMonthlyTable(date);
    
    return {
      'date': date,
      'dayOfYear': date.difference(DateTime(date.year, 1, 1)).inDays + 1,
      'eotAccurate': accurate,
      'eotSimple': simple,
      'eotMonthly': monthly,
      'solarTimeDifference': '${accurate > 0 ? '+' : ''}${accurate.toStringAsFixed(2)} minutes',
      'description': _getDescription(accurate),
    };
  }
  
  /// Get human-readable description of EoT effect
  static String _getDescription(double eot) {
    if (eot > 0) {
      return 'Sun is ahead of clock by ${eot.toStringAsFixed(1)} minutes';
    } else {
      return 'Sun is behind clock by ${(-eot).toStringAsFixed(1)} minutes';
    }
  }
  
  /// Check if a year is a leap year
  static bool _isLeapYear(int year) {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    if (year % 400 != 0) return false;
    return true;
  }
  
  /// Verify EoT calculation with known values
  /// 
  /// Returns true if calculations are within acceptable range
  static bool verify() {
    // Known approximate EoT values for specific dates
    final testCases = {
      DateTime(2024, 2, 14): -14.0,  // Near maximum negative
      DateTime(2024, 5, 15): 3.5,    // Moderate positive
      DateTime(2024, 9, 1): 0.0,     // Near zero
      DateTime(2024, 11, 3): 16.0,   // Near maximum positive
    };
    
    bool allPass = true;
    for (var entry in testCases.entries) {
      final date = entry.key;
      final expected = entry.value;
      final calculated = calculate(date);
      
      // Allow ±2 minutes tolerance due to year-to-year variations
      if ((calculated - expected).abs() > 2.0) {
        print('EoT Test Warning: $date');
        print('  Expected: ~$expected minutes');
        print('  Got: ${calculated.toStringAsFixed(2)} minutes');
        allPass = false;
      }
    }
    
    return allPass;
  }
}

/// Extension methods for DateTime to easily access EoT
extension DateTimeEoT on DateTime {
  /// Get the Equation of Time for this date
  double get equationOfTime => EquationOfTime.calculate(this);
  
  /// Convert mean solar time to apparent solar time
  DateTime get apparentSolarTime => EquationOfTime.applyCorrectionToMeanTime(this);
}
