/// Extended Solar Terms (Ipchun) Data: 1950-2050
/// 
/// This data provides minute-level precision for Ipchun (立春) dates
/// which mark the beginning of the Saju year.
/// 
/// Format: year -> [month, day, hour, minute]
/// All times are in KST (Korea Standard Time)
/// 
/// Data source: Astronomical calculations based on solar longitude 315°
/// 
/// Note: For years before 1950 or after 2050, the fallback approximation
/// (Feb 4, ~04:00) will be used.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ExtendedIpchunData {
  /// Ipchun data loaded from JSON file
  /// Format: year -> [month, day, hour, minute]
  static Map<int, List<int>> data = {};
  
  /// Initialize Ipchun data from JSON file
  /// Should be called once at app startup before any calculations
  /// Loads 101 years (1950-2050) of Ipchun data into memory
  static Future<void> initialize() async {
    try {
      // Load JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/json/ipchun.json');
      
      // Parse JSON and convert to typed Map structure
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      jsonMap.forEach((yearKey, termList) {
        int year = int.parse(yearKey);
        data[year] = (termList as List).map((e) => e as int).toList();
      });
      
      print('✅ 입춘 데이터 로딩 완료: ${data.length}년치');
    } catch (e) {
      print('❌ 입춘 데이터 로딩 실패: $e');
      // In case of failure, app will fall back to approximate calculations
    }
  }
  
  /// Get Ipchun date for a specific year
  /// Returns null if year is out of range
  static DateTime? getIpchunDate(int year) {
    final data = ExtendedIpchunData.data[year];
    if (data == null) return null;
    
    return DateTime(year, data[0], data[1], data[2], data[3]);
  }
  
  /// Check if data exists for a given year
  static bool hasDataFor(int year) {
    return data.containsKey(year);
  }
  
  /// Get year range covered by this dataset
  static List<int> get yearRange => [1950, 2050];
}
