import 'package:app_project/core/utils/time_correction.dart';
import 'package:app_project/core/utils/saju_engine.dart';
import 'package:app_project/data/models/saju_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeCorrection Tests', () {
    test('Seoul longitude correction in current era (1961-)', () {
      // Seoul: 126.98°, Standard: 135° = -8.02° × 4 ≈ -32 minutes
      final date = DateTime(2024, 3, 15, 13, 0);
      final correction = TimeCorrection.getSolarTimeCorrection(date);
      
      expect(correction, closeTo(-32, 2)); // Allow ±2 minutes tolerance
    });

    test('1958 era uses 127.5° standard (no correction)', () {
      // 1954-1961: Standard was 127.5°, Seoul is 126.98°
      // Difference is -0.52° × 4 ≈ -2 minutes (minimal)
      final date = DateTime(1958, 6, 15, 13, 0);
      final correction = TimeCorrection.getSolarTimeCorrection(date);
      
      expect(correction.abs(), lessThan(5)); // Very small correction
    });

    test('1988 Summer Time correction (-60 minutes)', () {
      // May 8 - Oct 9, 1988
      final summer = DateTime(1988, 7, 15, 13, 0);
      final winterBefore = DateTime(1988, 3, 15, 13, 0);
      final winterAfter = DateTime(1988, 11, 15, 13, 0);
      
      final summerCorrection = TimeCorrection.getSolarTimeCorrection(summer);
      final winterBeforeCorrection = TimeCorrection.getSolarTimeCorrection(winterBefore);
      final winterAfterCorrection = TimeCorrection.getSolarTimeCorrection(winterAfter);
      
      // Summer: -32 (longitude) + -60 (DST) = -92
      expect(summerCorrection, closeTo(-92, 2));
      
      // Winter: only longitude correction
      expect(winterBeforeCorrection, closeTo(-32, 2));
      expect(winterAfterCorrection, closeTo(-32, 2));
    });

    test('Solar time conversion accuracy', () {
      final clockTime = DateTime(2024, 3, 15, 13, 0);
      final solarTime = TimeCorrection.toSolarTime(clockTime);
      
      // 13:00 - 32 minutes = 12:28
      expect(solarTime.hour, 12);
      expect(solarTime.minute, closeTo(28, 2));
    });
  });

  group('Hour Pillar (Si-Ju) Tests', () {
    test('O-Si/Mi-Si boundary with solar correction', () {
      // Modern era: 13:00 boundary
      // Clock 13:00 → Solar ~12:28 → still O-Si
      // Clock 13:30 → Solar ~12:58 → still O-Si
      // Clock 13:35 → Solar ~13:03 → Mi-Si
      
      final date1 = DateTime(2024, 3, 15, 13, 0);
      final date2 = DateTime(2024, 3, 15, 13, 30);
      final date3 = DateTime(2024, 3, 15, 13, 35);
      
      final settings = SajuSettings(useSolarTimeCorrection: true);
      
      final hour1 = SajuEngine.getHourGanJi(date1, settings: settings);
      final hour2 = SajuEngine.getHourGanJi(date2, settings: settings);
      final hour3 = SajuEngine.getHourGanJi(date3, settings: settings);
      
      // Both should contain O (午)
      expect(hour1, contains('오'));
      expect(hour2, contains('오'));
      
      // This should contain Mi (未)
      expect(hour3, contains('미'));
    });

    test('1958 era O-Si/Mi-Si boundary (minimal correction)', () {
      // 1954-1961 era: Standard is 127.5°, minimal correction
      // 13:00 boundary should be nearly unchanged
      
      final date1 = DateTime(1958, 6, 15, 12, 58);
      final date2 = DateTime(1958, 6, 15, 13, 2);
      
      final settings = SajuSettings(useSolarTimeCorrection: true);
      
      final hour1 = SajuEngine.getHourGanJi(date1, settings: settings);
      final hour2 = SajuEngine.getHourGanJi(date2, settings: settings);
      
      expect(hour1, contains('오'));
      expect(hour2, contains('미'));
    });

    test('Ya-Ja-Si logic (23:00-23:59)', () {
      final yaJaSiTime = DateTime(2024, 3, 15, 23, 30);
      
      // With Ya-Ja-Si: hour is Ja but day doesn't change
      final settingsYa = SajuSettings(
        useYaJaSi: true,
        useSolarTimeCorrection: false, // Disable for simpler test
      );
      
      // Without Ya-Ja-Si: traditional method (day changes at 23:00)
      final settingsTraditional = SajuSettings(
        useYaJaSi: false,
        useSolarTimeCorrection: false,
      );
      
      final hourYa = SajuEngine.getHourGanJi(yaJaSiTime, settings: settingsYa);
      final hourTraditional = SajuEngine.getHourGanJi(yaJaSiTime, settings: settingsTraditional);
      
      // Both should have Ja (자) as hour branch
      expect(hourYa, contains('자'));
      expect(hourTraditional, contains('자'));
      
      // The Gan (천간) might differ based on day pillar calculation
      // This is the key difference of Ya-Ja-Si
    });
  });

  group('Integration Tests', () {
    test('Complete Saju calculation with corrections', () {
      final birthTime = DateTime(1990, 5, 20, 14, 30);
      final settings = SajuSettings(useSolarTimeCorrection: true);
      
      final saju = SajuEngine.getSaju(birthTime, settings: settings);
      
      expect(saju, contains('year'));
      expect(saju, contains('month'));
      expect(saju, contains('day'));
      expect(saju, contains('hour'));
      
      // Should have all 8 characters (4 pillars)
      expect(saju['year']!.length, 2);
      expect(saju['month']!.length, 2);
      expect(saju['day']!.length, 2);
      expect(saju['hour']!.length, 2);
    });

    test('Correction details output', () {
      final date = DateTime(2024, 3, 15, 13, 0);
      final details = TimeCorrection.getCorrectionDetails(date);
      
      expect(details, contains('clockTime'));
      expect(details, contains('solarTime'));
      expect(details, contains('totalCorrection'));
      expect(details, contains('era'));
      
      expect(details['era'], contains('현행 표준시'));
    });
  });

  group('Edge Cases', () {
    test('Pre-standardization era (before 1908)', () {
      final date = DateTime(1900, 1, 1, 12, 0);
      final correction = TimeCorrection.getSolarTimeCorrection(date);
      
      // Before standardization, should use local time (minimal correction)
      expect(correction, 0);
    });

    test('Transition dates between eras', () {
      final endOf1953 = DateTime(1953, 12, 31, 12, 0);
      final startOf1954 = DateTime(1954, 1, 1, 12, 0);
      
      final correction1953 = TimeCorrection.getSolarTimeCorrection(endOf1953);
      final correction1954 = TimeCorrection.getSolarTimeCorrection(startOf1954);
      
      // 1953: 135° standard, 1954: 127.5° standard
      // Should have different corrections
      expect(correction1953, isNot(equals(correction1954)));
    });
  });
}
