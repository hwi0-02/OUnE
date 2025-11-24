/// Monthly Solar Terms Data (12 Jeolgi)
/// 
/// Provides the start time for each of the 12 main solar terms (Jeol)
/// which determine the month pillar (Wol-Geon) in Saju calculations.
/// 
/// Format: year -> month -> [day, hour, minute]
/// All times are in KST
/// 
/// The 12 Jeolgi (節氣):
/// 1. Ipchun (立春) - 315° - Start of Yin month (寅月)
/// 2. Gyeongchip (驚蟄) - 345° - Start of Myo month (卯月)
/// 3. Cheongmyeong (清明) - 15° - Start of Jin month (辰月)
/// 4. Ipha (立夏) - 45° - Start of Sa month (巳月)
/// 5. Mangjong (芒種) - 75° - Start of O month (午月)
/// 6. Soseo (小暑) - 105° - Start of Mi month (未月)
/// 7. Ipchu (立秋) - 135° - Start of Sin month (申月)
/// 8. Baengno (白露) - 165° - Start of Yu month (酉月)
/// 9. Hallo (寒露) - 195° - Start of Sul month (戌月)
/// 10. Ipdong (立冬) - 225° - Start of Hae month (亥月)
/// 11. Daeseol (大雪) - 255° - Start of Ja month (子月)
/// 12. Sohan (小寒) - 285° - Start of Chuk month (丑月)

class MonthlySolarTermsData {
  /// Sample data for 2024 (can be expanded to cover 1950-2050)
  /// Month index: 1=Yin(Feb), 2=Myo(Mar), ..., 12=Chuk(Jan of next year)
  static final Map<int, Map<int, List<int>>> data = {
    2024: {
      1:  [2, 4, 16, 27],   // Ipchun (Yin month start)
      2:  [3, 5, 10, 23],   // Gyeongchip (Myo month start)
      3:  [4, 4, 15, 2],    // Cheongmyeong (Jin month start)
      4:  [5, 5, 8, 10],    // Ipha (Sa month start)
      5:  [6, 5, 12, 10],   // Mangjong (O month start)
      6:  [7, 6, 22, 44],   // Soseo (Mi month start)
      7:  [8, 7, 9, 9],     // Ipchu (Sin month start)
      8:  [9, 7, 11, 11],   // Baengno (Yu month start)
      9:  [10, 8, 2, 15],   // Hallo (Sul month start)
      10: [11, 7, 6, 20],   // Ipdong (Hae month start)
      11: [12, 6, 23, 17],  // Daeseol (Ja month start)
      12: [1, 6, 5, 12],    // Sohan of next year (Chuk month start)
    },
    2025: {
      1:  [2, 3, 22, 7],
      2:  [3, 5, 16, 7],
      3:  [4, 4, 20, 49],
      4:  [5, 5, 13, 57],
      5:  [6, 5, 17, 57],
      6:  [7, 7, 4, 31],
      7:  [8, 7, 14, 56],
      8:  [9, 7, 16, 58],
      9:  [10, 8, 8, 2],
      10: [11, 7, 12, 7],
      11: [12, 7, 5, 5],
      12: [1, 5, 17, 55],  // 2025 Sohan (Jan 5)
    },
    2026: {
      12: [1, 5, 23, 1], // 2026 Sohan
    },
  };
  
  /// Get solar term date for a specific year and month
  /// [year] - Gregorian year
  /// [monthIndex] - Saju month index (1-12)
  static DateTime? getSolarTermDate(int year, int monthIndex) {
    final yearData = data[year];
    if (yearData == null) return null;
    
    final termData = yearData[monthIndex];
    if (termData == null) return null;
    
    // Handle cross-year case (Sohan of next year)
    if (termData.length > 4) {
      return DateTime(termData[0], termData[1], termData[2], termData[3], termData[4]);
    }
    
    return DateTime(year, termData[0], termData[1], termData[2], termData[3]);
  }
  
  /// Get the Saju month index for a given date
  /// Returns 1-12 corresponding to Yin-Chuk months
  /// Returns null if data is not available for the year
  static int? getSajuMonthIndex(DateTime date) {
    final yearData = data[date.year];
    if (yearData == null) {
      // Fallback to approximate calculation
      return _approximateSajuMonth(date);
    }
    
    // Check each month's start time
    for (int monthIndex = 1; monthIndex <= 12; monthIndex++) {
      final termDate = getSolarTermDate(date.year, monthIndex);
      if (termDate == null) continue;
      
      final nextMonthIndex = monthIndex == 12 ? 1 : monthIndex + 1;
      final nextYear = monthIndex == 12 ? date.year + 1 : date.year;
      final nextTermDate = getSolarTermDate(nextYear, nextMonthIndex);
      
      if (nextTermDate == null) {
        // If next term is unknown, use this month if date is after current term
        if (date.isAfter(termDate) || date.isAtSameMomentAs(termDate)) {
          return monthIndex;
        }
      } else {
        // Date is in this month if it's between this term and next term
        if ((date.isAfter(termDate) || date.isAtSameMomentAs(termDate)) && 
            date.isBefore(nextTermDate)) {
          return monthIndex;
        }
      }
    }
    
    return null;
  }
  
  /// Approximate Saju month calculation (fallback)
  static int _approximateSajuMonth(DateTime date) {
    // Simple approximation based on Gregorian calendar
    // This is less accurate but better than nothing
    const approximateDays = [
      6,  // Sohan (Jan)
      4,  // Ipchun (Feb)
      6,  // Gyeongchip (Mar)
      5,  // Cheongmyeong (Apr)
      6,  // Ipha (May)
      6,  // Mangjong (Jun)
      7,  // Soseo (Jul)
      8,  // Ipchu (Aug)
      8,  // Baengno (Sep)
      9,  // Hallo (Oct)
      8,  // Ipdong (Nov)
      7   // Daeseol (Dec)
    ];
    
    int sajuMonthIndex;
    if (date.day >= approximateDays[date.month - 1]) {
      sajuMonthIndex = date.month - 2; // Feb is 0 (Yin month)
    } else {
      sajuMonthIndex = date.month - 3;
    }
    
    if (sajuMonthIndex < 0) sajuMonthIndex += 12;
    return sajuMonthIndex + 1; // Convert to 1-indexed
  }
  
  /// Check if data exists for a given year
  static bool hasDataFor(int year) {
    return data.containsKey(year);
  }

  /// Get all solar terms for a specific year
  /// Used by DaeunCalculator for precise term-based calculations
  /// Returns null if data is not available for the year
  static List<Map<String, dynamic>>? getSolarTermsForYear(int year) {
    final yearData = data[year];
    if (yearData == null) return null;

    final List<Map<String, dynamic>> terms = [];
    for (int monthIndex = 1; monthIndex <= 12; monthIndex++) {
      final termDate = getSolarTermDate(year, monthIndex);
      if (termDate != null) {
        terms.add({
          'index': monthIndex,
          'date': termDate,
        });
      }
    }
    return terms;
  }
}
