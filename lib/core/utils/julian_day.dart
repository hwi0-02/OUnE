/// Julian Day Number (JDN) Utilities
/// 
/// Provides conversion between Gregorian calendar dates and Julian Day Numbers,
/// which is the standard astronomical timekeeping system.
/// 
/// JDN is the number of days since January 1, 4713 BC (proleptic Julian calendar)
/// at noon UTC. This continuous day count simplifies date calculations.
class JulianDay {
  /// Convert a DateTime to Julian Day Number
  /// 
  /// Based on Jean Meeus's "Astronomical Algorithms" (1998)
  /// 
  /// Example:
  /// ```dart
  /// final jdn = JulianDay.fromDateTime(DateTime(2000, 1, 1, 12, 0));
  /// print(jdn); // 2451545.0 (J2000.0 epoch)
  /// ```
  static double fromDateTime(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    
    // Convert time to fraction of day
    double dayFraction = (date.hour + 
                         date.minute / 60.0 + 
                         date.second / 3600.0) / 24.0;
    
    // Adjust for January/February being in previous year for the algorithm
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    
    // Gregorian calendar correction
    int a = year ~/ 100;
    int b = 2 - a + (a ~/ 4);
    
    // Calculate JDN using Meeus formula
    int jdnInteger = (365.25 * (year + 4716)).floor() +
                     (30.6001 * (month + 1)).floor() +
                     day + b - 1524;
    
    return jdnInteger + dayFraction;
  }
  
  /// Convert a Julian Day Number to DateTime
  /// 
  /// Inverse operation of fromDateTime()
  static DateTime toDateTime(double jdn) {
    int z = (jdn + 0.5).floor();
    double f = (jdn + 0.5) - z;
    
    int a;
    if (z < 2299161) {
      a = z;
    } else {
      int alpha = ((z - 1867216.25) / 36524.25).floor();
      a = z + 1 + alpha - (alpha ~/ 4);
    }
    
    int b = a + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    int e = ((b - d) / 30.6001).floor();
    
    int day = b - d - (30.6001 * e).floor();
    int month = e < 14 ? e - 1 : e - 13;
    int year = month > 2 ? c - 4716 : c - 4715;
    
    // Calculate time from fraction
    double timeFraction = f * 24;
    int hour = timeFraction.floor();
    double minuteFraction = (timeFraction - hour) * 60;
    int minute = minuteFraction.floor();
    double secondFraction = (minuteFraction - minute) * 60;
    int second = secondFraction.floor();
    
    return DateTime(year, month, day, hour, minute, second);
  }
  
  /// Get the day of week (0 = Monday, 6 = Sunday)
  static int getDayOfWeek(double jdn) {
    return ((jdn + 1.5) % 7).floor();
  }
  
  /// Calculate the difference in days between two dates
  /// 
  /// This is the astronomical standard way to calculate date differences,
  /// avoiding calendar-specific complexities.
  static double daysBetween(DateTime date1, DateTime date2) {
    return fromDateTime(date2) - fromDateTime(date1);
  }
  
  /// Verify JDN calculation with known test cases
  /// 
  /// Returns true if all test cases pass
  static bool verify() {
    // Test cases from Jean Meeus's book
    final testCases = [
      // Date, Expected JDN
      [DateTime(2000, 1, 1, 12, 0), 2451545.0],  // J2000.0 epoch
      [DateTime(1987, 1, 27, 0, 0), 2446822.5],  // Meeus Example 7.a
      [DateTime(1987, 6, 19, 12, 0), 2446966.0], // Meeus Example 7.b
      [DateTime(1900, 1, 1, 0, 0), 2415020.5],   // 1900 start
      [DateTime(2024, 1, 1, 0, 0), 2460310.5],   // Recent test
    ];
    
    bool allPass = true;
    for (var testCase in testCases) {
      final date = testCase[0] as DateTime;
      final expected = testCase[1] as double;
      final calculated = fromDateTime(date);
      
      // Allow small floating point error (< 0.001 days = ~1 minute)
      if ((calculated - expected).abs() > 0.001) {
        print('JDN Test Failed: $date');
        print('  Expected: $expected');
        print('  Got: $calculated');
        allPass = false;
      }
    }
    
    return allPass;
  }
}

/// Extension methods for DateTime to easily access JDN
extension DateTimeJDN on DateTime {
  /// Get the Julian Day Number for this DateTime
  double get julianDayNumber => JulianDay.fromDateTime(this);
  
  /// Calculate days difference using JDN
  double daysUntil(DateTime other) => JulianDay.daysBetween(this, other);
}
