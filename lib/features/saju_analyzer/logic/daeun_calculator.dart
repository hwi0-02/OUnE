/// Gender enum for Saju analysis
enum Gender {
  male,
  female,
}

/// Direction of Daeun (Major Fortune) cycle
enum DaeunDirection {
  forward,  // 순행
  backward, // 역행
}

/// Single Daeun (Major Fortune) period
class DaeunPeriod {
  final int startAge;
  final int endAge;
  final String ganJi;
  final String gan;
  final String ji;
  
  const DaeunPeriod({
    required this.startAge,
    required this.endAge,
    required this.ganJi,
    required this.gan,
    required this.ji,
  });
  
  @override
  String toString() => '$startAge-$endAge세: $ganJi';
}

/// Daeun (Major Fortune) Calculator
/// 
/// Calculates the 10-year fortune cycles based on:
/// - Birth date and time
/// - Gender
/// - Distance to nearest solar term (절기)
class DaeunCalculator {
  /// Calculate Daeun start age
  /// 
  /// Formula: (Days to nearest Jeolgi) ÷ 3 = Years
  /// 
  /// [birthDate] - Birth date and time
  /// [gender] - Gender (male or female)
  /// [monthGanJi] - Month pillar GanJi
  /// 
  /// Returns the age when first Daeun begins
  static int calculateDaeunStartAge({
    required DateTime birthDate,
    required Gender gender,
    required String monthGanJi,
  }) {
    // Determine if year is Yang or Yin
    final yearGan = monthGanJi.substring(0, 1);
    final isYangYear = _isYangGan(yearGan);
    
    // Determine direction
    final direction = _getDaeunDirection(isYangYear, gender);
    
    // Get nearest solar term
    final daysToTerm = _getDaysToNearestTerm(birthDate, direction);
    
    // Calculate age: days ÷ 3 = years
    final startAge = (daysToTerm / 3).round();
    
    return startAge;
  }
  
  /// Generate list of Daeun periods
  /// 
  /// [birthDate] - Birth date
  /// [gender] - Gender
  /// [monthGanJi] - Month pillar (used to determine direction)
  /// [maxAge] - Maximum age to calculate (default: 100)
  /// 
  /// Returns list of Daeun periods
  static List<DaeunPeriod> calculateDaeunPeriods({
    required DateTime birthDate,
    required Gender gender,
    required String monthGanJi,
    int maxAge = 100,
  }) {
    // Calculate start age
    final startAge = calculateDaeunStartAge(
      birthDate: birthDate,
      gender: gender,
      monthGanJi: monthGanJi,
    );
    
    // Get direction
    final yearGan = monthGanJi.substring(0, 1);
    final isYangYear = _isYangGan(yearGan);
    final direction = _getDaeunDirection(isYangYear, gender);
    
    // Get month GanJi index in 60-cycle
    final monthIndex = _getGanJiIndex(monthGanJi);
    
    final periods = <DaeunPeriod>[];
    int currentAge = startAge;
    int currentIndex = monthIndex;
    
    while (currentAge < maxAge) {
      // Move to next/previous GanJi based on direction
      if (direction == DaeunDirection.forward) {
        currentIndex = (currentIndex + 1) % 60;
      } else {
        currentIndex = (currentIndex - 1 + 60) % 60;
      }
      
      final ganJi = _getGanJiFromIndex(currentIndex);
      
      periods.add(DaeunPeriod(
        startAge: currentAge,
        endAge: currentAge + 9,
        ganJi: ganJi,
        gan: ganJi.substring(0, 1),
        ji: ganJi.substring(1, 2),
      ));
      
      currentAge += 10;
    }
    
    return periods;
  }
  
  /// Get Daeun for a specific age
  static DaeunPeriod? getDaeunAtAge({
    required int age,
    required List<DaeunPeriod> periods,
  }) {
    for (var period in periods) {
      if (age >= period.startAge && age <= period.endAge) {
        return period;
      }
    }
    return null;
  }
  
  /// Check if a heavenly stem is Yang
  static bool _isYangGan(String gan) {
    const yangGans = ['갑', '병', '무', '경', '임'];
    return yangGans.contains(gan);
  }
  
  /// Determine Daeun direction based on Yang/Yin year and gender
  /// 
  /// 양남음녀 (Yang male, Yin female) → Forward
  /// 음남양녀 (Yin male, Yang female) → Backward
  static DaeunDirection _getDaeunDirection(bool isYangYear, Gender gender) {
    if (isYangYear && gender == Gender.male) {
      return DaeunDirection.forward; // 양남 순행
    }
    if (!isYangYear && gender == Gender.female) {
      return DaeunDirection.forward; // 음녀 순행
    }
    return DaeunDirection.backward; // 음남 or 양녀 역행
  }
  
  /// Get days to nearest solar term
  /// 
  /// Forward: days to NEXT term
  /// Backward: days to PREVIOUS term
  static int _getDaysToNearestTerm(DateTime birthDate, DaeunDirection direction) {
    // Simplified: use approximate solar term dates
    // In production, should use precise solar term data
    
    // Approximate monthly solar terms (day of month)
    const solarTermDays = [
      6,  // Jan - Sohan
      4,  // Feb - Ipchun
      6,  // Mar - Gyeongchip
      5,  // Apr - Cheongmyeong
      6,  // May - Ipha
      6,  // Jun - Mangjong
      7,  // Jul - Soseo
      8,  // Aug - Ipchu
      8,  // Sep - Baengno
      8,  // Oct - Hallo
      7,  // Nov - Ipdong
      7,  // Dec - Daeseol
    ];
    
    final currentMonth = birthDate.month;
    final currentDay = birthDate.day;
    final termDay = solarTermDays[currentMonth - 1];
    
    int daysToTerm;
    
    if (direction == DaeunDirection.forward) {
      // Days to NEXT term
      if (currentDay < termDay) {
        // Term is in current month
        daysToTerm = termDay - currentDay;
      } else {
        // Term is in next month
        final daysInCurrentMonth = DateTime(birthDate.year, currentMonth + 1, 0).day;
        final daysRemainingInMonth = daysInCurrentMonth - currentDay;
        final nextMonth = currentMonth == 12 ? 1 : currentMonth + 1;
        final nextTermDay = solarTermDays[nextMonth - 1];
        daysToTerm = daysRemainingInMonth + nextTermDay;
      }
    } else {
      // Days to PREVIOUS term
      if (currentDay >= termDay) {
        // Term is in current month (already passed)
        daysToTerm = currentDay - termDay;
      } else {
        // Term is in previous month
        final prevMonth = currentMonth == 1 ? 12 : currentMonth - 1;
        final prevYear = currentMonth == 1 ? birthDate.year - 1 : birthDate.year;
        final daysInPrevMonth = DateTime(prevYear, prevMonth + 1, 0).day;
        final prevTermDay = solarTermDays[prevMonth - 1];
        daysToTerm = currentDay + (daysInPrevMonth - prevTermDay);
      }
    }
    
    return daysToTerm;
  }
  
  /// Get 60 GanJi index from GanJi string
  static int _getGanJiIndex(String ganJi) {
    const cheongan = ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'];
    const jiji = ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'];
    
    final gan = ganJi.substring(0, 1);
    final ji = ganJi.substring(1, 2);
    
    final ganIndex = cheongan.indexOf(gan);
    final jiIndex = jiji.indexOf(ji);
    
    // Find matching 60-cycle index
    for (int i = 0; i < 60; i++) {
      if (i % 10 == ganIndex && i % 12 == jiIndex) {
        return i;
      }
    }
    
    return 0;
  }
  
  /// Get GanJi string from 60-cycle index
  static String _getGanJiFromIndex(int index) {
    const cheongan = ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'];
    const jiji = ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'];
    
    final gan = cheongan[index % 10];
    final ji = jiji[index % 12];
    
    return '$gan$ji';
  }
}
