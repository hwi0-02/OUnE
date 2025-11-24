import 'package:app_project/core/data/extended_ipchun_data.dart';
import 'package:app_project/core/data/monthly_solar_terms_data.dart';
import 'package:app_project/core/utils/equation_of_time.dart';
import 'package:app_project/core/utils/julian_day.dart';
import 'package:app_project/core/utils/time_correction.dart';
import 'package:app_project/data/models/saju_settings.dart';

class SajuEngine {
  static const List<String> cheongan = ['갑', '을', '병', '정', '무', '기', '경', '신', '임', '계'];
  static const List<String> jiji = ['자', '축', '인', '묘', '진', '사', '오', '미', '신', '유', '술', '해'];
  static const List<String> ohaeng = ['목', '화', '토', '금', '수'];

  // Ohaeng mapping for Cheongan
  static const Map<String, String> cheonganOhaeng = {
    '갑': '목', '을': '목',
    '병': '화', '정': '화',
    '무': '토', '기': '토',
    '경': '금', '신': '금',
    '임': '수', '계': '수',
  };

  // Ohaeng mapping for Jiji
  static const Map<String, String> jijiOhaeng = {
    '인': '목', '묘': '목',
    '사': '화', '오': '화',
    '진': '토', '술': '토', '축': '토', '미': '토',
    '신': '금', '유': '금',
    '해': '수', '자': '수',
  };

  // Solar terms (Jeol-gi) approximate start days (Month 1 to 12)
  // Fallback for years not in extended data
  static const List<int> solarTermDays = [
    6,  // Sohan (Jan)
    4,  // Ipchun (Feb) - Start of Year in Saju
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

  /// Returns the Year Pillar (Year Gan-Ji)
  /// Note: Saju year starts at Ipchun (입춘), not Jan 1.
  static String getYearGanJi(DateTime date) {
    int year = date.year;
    
    // Try to get precise Ipchun data from extended dataset
    final ipchunDate = ExtendedIpchunData.getIpchunDate(year);
    if (ipchunDate != null) {
      // Use minute-level precision
      if (date.isBefore(ipchunDate)) {
        year--;
      }
    } else {
      // Fallback: approximate Ipchun as Feb 4
      if (date.month < 2 || (date.month == 2 && date.day < 4)) {
        year--;
      }
    }
    
    // 1924 was Gap-Ja year (Start of cycle)
    // (Year - 4) % 60 is the standard formula for Gregorian year
    int offset = (year - 4) % 60;
    return '${cheongan[offset % 10]}${jiji[offset % 12]}';
  }

  /// Returns the Month Pillar (Month Gan-Ji)
  /// Calculated based on Year Gan and the Solar Month
  static String getMonthGanJi(DateTime date) {
    // Try to use precise monthly solar terms data
    int? sajuMonthIndex = MonthlySolarTermsData.getSajuMonthIndex(date);
    
    if (sajuMonthIndex == null) {
      // Fallback to approximate calculation
      if (date.day >= solarTermDays[date.month - 1]) {
        sajuMonthIndex = date.month - 2; // Feb is 0
      } else {
        sajuMonthIndex = date.month - 3; // Jan is -1 -> 11
      }
      
      if (sajuMonthIndex < 0) sajuMonthIndex += 12;
      sajuMonthIndex += 1; // Convert to 1-indexed
    }
    
    // Adjust to 0-indexed for calculation
    sajuMonthIndex -= 1;
    
    // Year Gan Index for determining Month Gan
    String yearGan = getYearGanJi(date).substring(0, 1);
    int yearGanIndex = cheongan.indexOf(yearGan);
    
    int monthGanStartIndex;
    if (yearGanIndex % 5 == 0) monthGanStartIndex = 2; // Gap/Gi -> Byeong (2)
    else if (yearGanIndex % 5 == 1) monthGanStartIndex = 4; // Eul/Gyeong -> Mu (4)
    else if (yearGanIndex % 5 == 2) monthGanStartIndex = 6; // Byeong/Sin -> Gyeong (6)
    else if (yearGanIndex % 5 == 3) monthGanStartIndex = 8; // Jeong/Im -> Im (8)
    else monthGanStartIndex = 0; // Mu/Gye -> Gap (0)

    int monthGanIndex = (monthGanStartIndex + sajuMonthIndex) % 10;
    int monthJiIndex = (2 + sajuMonthIndex) % 12; // Month starts with In (Tiger) = index 2

    return '${cheongan[monthGanIndex]}${jiji[monthJiIndex]}';
  }

  /// Returns the Day Pillar (Day Gan-Ji)
  /// 
  /// Uses Julian Day Number (JDN) for astronomical accuracy.
  /// JDN provides a continuous day count independent of calendar systems.
  static String getDayGanJi(DateTime date) {
    // Reference: 2000-01-01 was Mu-O (戊午) = index 54 in 60-cycle
    final referenceDate = DateTime(2000, 1, 1);
    const referenceIndex = 54; // Mu-O in 0-59 cycle
    
    // Use Julian Day Number for precise day difference calculation
    // This is the astronomical standard method
    final jdnDiff = JulianDay.daysBetween(referenceDate, date);
    final daysDiff = jdnDiff.round();
    
    // Calculate current position in 60-day cycle
    int currentIndex = (referenceIndex + daysDiff) % 60;
    if (currentIndex < 0) currentIndex += 60;
    
    return '${cheongan[currentIndex % 10]}${jiji[currentIndex % 12]}';
  }

  /// Returns the Hour Pillar (Si-ju)
  /// Calculated based on Day Gan and the Hour
  /// 
  /// [date] - Birth datetime (clock time)
  /// [settings] - Saju calculation settings (solar time correction, Ya-Ja-Si)
  static String getHourGanJi(
    DateTime date, {
    SajuSettings settings = const SajuSettings(),
  }) {
    // Apply solar time correction if enabled
    DateTime effectiveTime = date;
    if (settings.useSolarTimeCorrection) {
      effectiveTime = TimeCorrection.toSolarTime(
        date,
        localLongitude: settings.localLongitude,
        applyEquationOfTime: settings.useEquationOfTime,
      );
    }
    
    // Determine the hour index (0-11, where 0 = 23:00-01:00)
    int hour = effectiveTime.hour;
    int hourIndex;
    
    // Hour to Ji mapping (2-hour periods)
    // 23:00-01:00 = Ja (0)
    // 01:00-03:00 = Chuk (1)
    // 03:00-05:00 = In (2)
    // 05:00-07:00 = Myo (3)
    // 07:00-09:00 = Jin (4)
    // 09:00-11:00 = Sa (5)
    // 11:00-13:00 = O (6)
    // 13:00-15:00 = Mi (7)
    // 15:00-17:00 = Sin (8)
    // 17:00-19:00 = Yu (9)
    // 19:00-21:00 = Sul (10)
    // 21:00-23:00 = Hae (11)
    
    if (hour >= 23 || hour < 1) {
      hourIndex = 0; // Ja
    } else {
      hourIndex = ((hour + 1) ~/ 2) % 12;
    }
    
    // Get Day Gan to determine Hour Gan start
    // For Ya-Ja-Si (23:00-23:59), use current day's Gan even though hour is Ja
    DateTime dateForDayGan = effectiveTime;
    if (settings.useYaJaSi && hour == 23) {
      // Ya-Ja-Si: keep current day for Day Gan calculation
      // Hour is Ja (next day's first hour) but day pillar doesn't change
      dateForDayGan = effectiveTime;
    }
    
    String dayGanJi = getDayGanJi(dateForDayGan);
    String dayGan = dayGanJi.substring(0, 1);
    int dayGanIndex = cheongan.indexOf(dayGan);
    
    // Hour Gan calculation based on Day Gan
    // Gap/Gi Day -> Ja-hour starts with Gap (0)
    // Eul/Gyeong Day -> Ja-hour starts with Byeong (2)
    // Byeong/Sin Day -> Ja-hour starts with Mu (4)
    // Jeong/Im Day -> Ja-hour starts with Gyeong (6)
    // Mu/Gye Day -> Ja-hour starts with Im (8)
    
    int hourGanStartIndex;
    if (dayGanIndex % 5 == 0) hourGanStartIndex = 0; // Gap/Gi
    else if (dayGanIndex % 5 == 1) hourGanStartIndex = 2; // Eul/Gyeong
    else if (dayGanIndex % 5 == 2) hourGanStartIndex = 4; // Byeong/Sin
    else if (dayGanIndex % 5 == 3) hourGanStartIndex = 6; // Jeong/Im
    else hourGanStartIndex = 8; // Mu/Gye
    
    int hourGanIndex = (hourGanStartIndex + hourIndex) % 10;
    
    return '${cheongan[hourGanIndex]}${jiji[hourIndex]}';
  }

  /// Returns complete Saju (Four Pillars) for a given date
  /// 
  /// [date] - Birth datetime (clock time)
  /// [settings] - Saju calculation settings
  static Map<String, String> getSaju(
    DateTime date, {
    SajuSettings settings = const SajuSettings(),
  }) {
    final yearGanJi = getYearGanJi(date);
    final monthGanJi = getMonthGanJi(date);
    final dayGanJi = getDayGanJi(date);
    final hourGanJi = getHourGanJi(date, settings: settings);
    
    return {
      'year': yearGanJi,
      'month': monthGanJi,
      'day': dayGanJi,
      'hour': hourGanJi,
      'yearGan': yearGanJi.substring(0, 1),
      'yearJi': yearGanJi.substring(1),
      'monthGan': monthGanJi.substring(0, 1),
      'monthJi': monthGanJi.substring(1),
      'dayGan': dayGanJi.substring(0, 1),
      'dayJi': dayGanJi.substring(1),
      'hourGan': hourGanJi.substring(0, 1),
      'hourJi': hourGanJi.substring(1),
    };
  }

  /// Checks if the date is near a solar term boundary (±1 day)
  static bool isSolarTermBoundary(DateTime date) {
    // Check if within 1 day of Ipchun
    final ipchunDate = ExtendedIpchunData.getIpchunDate(date.year);
    if (ipchunDate != null) {
      final diff = date.difference(ipchunDate).inDays.abs();
      if (diff <= 1) return true;
    }
    
    // Check month boundaries (simplified)
    if (date.day >= solarTermDays[date.month - 1] - 1 && 
        date.day <= solarTermDays[date.month - 1] + 1) {
      return true;
    }
    
    return false;
  }

  /// Returns the Ohaeng (Five Elements) for a given Gan or Ji
  static String getOhaeng(String char) {
    if (cheonganOhaeng.containsKey(char)) return cheonganOhaeng[char]!;
    if (jijiOhaeng.containsKey(char)) return jijiOhaeng[char]!;
    return '';
  }
  
  /// Returns compatibility description between two Ohaengs
  static String getOhaengRelationship(String me, String day) {
    // Simple generation/control logic
    // Wood(목) -> Fire(화) -> Earth(토) -> Metal(금) -> Water(수) -> Wood(목)
    if (me == day) return "같은 기운이 만나 힘이 되는 날";
    
    if ((me == '목' && day == '화') || (me == '화' && day == '토') || 
        (me == '토' && day == '금') || (me == '금' && day == '수') || 
        (me == '수' && day == '목')) {
      return "당신의 기운이 뻗어나가는 상생의 날";
    }
    
    if ((day == '목' && me == '화') || (day == '화' && me == '토') || 
        (day == '토' && me == '금') || (day == '금' && me == '수') || 
        (day == '수' && me == '목')) {
      return "주변의 도움을 받아 기운이 솟는 날";
    }
    
    return "새로운 자극이 들어오는 변화의 날";
  }

  /// Returns Shinsal (Divine Spirits) - Specifically Cheon-eul-gwi-in (Nobleman)
  /// Based on Day Master (Il-gan) and Day Branch (Il-ji) or Year Branch (Year-ji)
  /// Simplified: Checks if Today's Ji is a Nobleman for User's Day Gan.
  static String getShinsal(String userDayGan, String todayJi) {
    // Cheon-eul-gwi-in Mapping
    // Gap/Mu/Gyeong -> Chuk(Ox), Mi(Goat)
    // Eul/Gi -> Ja(Rat), Sin(Monkey)
    // Byeong/Jeong -> Hae(Pig), Yu(Rooster)
    // Sin -> In(Tiger), O(Horse) -> Wait, Sin is Metal.
    // Let's use standard table:
    // Gap/Mu/Gyeong -> Chuk, Mi
    // Eul/Gi -> Ja, Sin
    // Byeong/Jeong -> Hae, Yu
    // Sin -> O, In
    // Im/Gye -> Sa, Myo
    
    final Map<String, List<String>> noblemanMap = {
      '갑': ['축', '미'], '무': ['축', '미'], '경': ['축', '미'],
      '을': ['자', '신'], '기': ['자', '신'],
      '병': ['해', '유'], '정': ['해', '유'],
      '신': ['오', '인'],
      '임': ['사', '묘'], '계': ['사', '묘'],
    };

    if (noblemanMap.containsKey(userDayGan)) {
      if (noblemanMap[userDayGan]!.contains(todayJi)) {
        return "천을귀인(귀인의 도움)";
      }
    }
    
    return "";
  }
}
