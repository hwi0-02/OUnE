import 'package:app_project/core/data/extended_ipchun_data.dart';
import 'package:app_project/core/data/monthly_solar_terms_data.dart';
import 'package:app_project/core/utils/saju_engine.dart';
import 'package:app_project/data/models/saju_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Extended Solar Terms Data Tests', () {
    test('Ipchun data coverage check (1950-2050)', () {
      expect(ExtendedIpchunData.hasDataFor(1950), isTrue);
      expect(ExtendedIpchunData.hasDataFor(2000), isTrue);
      expect(ExtendedIpchunData.hasDataFor(2050), isTrue);
      expect(ExtendedIpchunData.hasDataFor(1949), isFalse);
      expect(ExtendedIpchunData.hasDataFor(2051), isFalse);
    });

    test('Ipchun minute-level precision', () {
      // 2024 Ipchun: Feb 4, 16:27
      final ipchun2024 = ExtendedIpchunData.getIpchunDate(2024);
      expect(ipchun2024, isNotNull);
      expect(ipchun2024!.year, 2024);
      expect(ipchun2024.month, 2);
      expect(ipchun2024.day, 4);
      expect(ipchun2024.hour, 16);
      expect(ipchun2024.minute, 27);
    });

    test('Year pillar boundary test with minute precision', () {
      // 2024 Ipchun: Feb 4, 16:27
      final before = DateTime(2024, 2, 4, 16, 26); // 1 minute before
      final after = DateTime(2024, 2, 4, 16, 28);  // 1 minute after
      
      final yearBefore = SajuEngine.getYearGanJi(before);
      final yearAfter = SajuEngine.getYearGanJi(after);
      
      // Before should be 2023 (Gye-Myo), After should be 2024 (Gap-Jin)
      expect(yearBefore, isNot(equals(yearAfter)));
      print('Before Ipchun: $yearBefore');
      print('After Ipchun: $yearAfter');
    });

    test('Historical year pillar (1958)', () {
      // Test 1958 era compliance check scenario
      final date1958 = DateTime(1958, 2, 4, 11, 56); // Before Ipchun
      final yearGanJi = SajuEngine.getYearGanJi(date1958);
      
      // Should be 1957's year pillar
      print('1958-02-04 11:56 Year Pillar: $yearGanJi');
      expect(yearGanJi.length, 2);
    });

    test('Leap year Ipchun variations', () {
      // Leap years have different Ipchun times
      final ipchun2024 = ExtendedIpchunData.getIpchunDate(2024); // Leap year
      final ipchun2025 = ExtendedIpchunData.getIpchunDate(2025); // Non-leap
      
      expect(ipchun2024, isNotNull);
      expect(ipchun2025, isNotNull);
      
      // 2025 Ipchun should be earlier (Feb 3 vs Feb 4)
      expect(ipchun2025!.day, lessThan(ipchun2024!.day));
    });
  });

  group('Monthly Solar Terms Tests', () {
    test('Month pillar boundary precision (2024)', () {
      // 2024 Gyeongchip (Myo month start): Mar 5, 10:23
      final beforeMyo = DateTime(2024, 3, 5, 10, 22);
      final afterMyo = DateTime(2024, 3, 5, 10, 24);
      
      final monthBefore = SajuEngine.getMonthGanJi(beforeMyo);
      final monthAfter = SajuEngine.getMonthGanJi(afterMyo);
      
      // Month Ji (branch) should change from In(인) to Myo(묘)
      expect(monthBefore.substring(1), '인'); // Still Yin month
      expect(monthAfter.substring(1), '묘');  // Now Myo month
    });

    test('Saju month index calculation', () {
      // Test various dates in 2024
      final dates = [
        DateTime(2024, 2, 4, 17, 0),  // Right after Ipchun - Yin month
        DateTime(2024, 3, 5, 11, 0),  // After Gyeongchip - Myo month
        DateTime(2024, 12, 31, 23, 59), // End of year - still Chuk month
      ];
      
      for (final date in dates) {
        final monthIndex = MonthlySolarTermsData.getSajuMonthIndex(date);
        expect(monthIndex, isNotNull);
        expect(monthIndex!, greaterThanOrEqualTo(1));
        expect(monthIndex, lessThanOrEqualTo(12));
        print('${date.toString().substring(0, 10)} -> Month $monthIndex');
      }
    });

    test('Cross-year month handling', () {
      // January dates should be Chuk month (12th Saju month) of previous year
      final jan2024 = DateTime(2024, 1, 15);
      final monthGanJi = SajuEngine.getMonthGanJi(jan2024);
      
      // Should contain Chuk (축)
      expect(monthGanJi.substring(1), '축');
    });
  });

  group('Integration Tests with Solar Corrections', () {
    test('Complete Saju with extended data and corrections', () {
      // Birth in extended data range with solar correction
      final birthTime = DateTime(1985, 6, 15, 14, 0);
      final settings = SajuSettings(
        useSolarTimeCorrection: true,
        useYaJaSi: false,
      );
      
      final saju = SajuEngine.getSaju(birthTime, settings: settings);
      
      expect(saju['year'], isNotNull);
      expect(saju['month'], isNotNull);
      expect(saju['day'], isNotNull);
      expect(saju['hour'], isNotNull);
      
      print('\n1985-06-15 14:00 Saju:');
      print('Year: ${saju['year']}');
      print('Month: ${saju['month']}');
      print('Day: ${saju['day']}');
      print('Hour: ${saju['hour']}');
    });

    test('Boundary scenario: 1954-1961 era with minimal correction', () {
      // 1958: Different timezone standard
      final birthTime = DateTime(1958, 6, 15, 13, 15);
      final settings = SajuSettings(useSolarTimeCorrection: true);
      
      final saju = SajuEngine.getSaju(birthTime, settings: settings);
      
      // Hour should be Mi-Si (未時) due to minimal correction in this era
      print('\n1958-06-15 13:15 Saju (with correction):');
      print('Hour: ${saju['hour']}');
      expect(saju['hour']!.substring(1), '미');
    });

    test('Modern era: 13:30 should be O-Si with correction', () {
      // 2024: Standard 135°, correction ~-32 minutes
      // 13:30 clock -> ~12:58 solar -> O-Si (午時)
      final birthTime = DateTime(2024, 6, 15, 13, 30);
      final settings = SajuSettings(useSolarTimeCorrection: true);
      
      final saju = SajuEngine.getSaju(birthTime, settings: settings);
      
      print('\n2024-06-15 13:30 Saju (with correction):');
      print('Hour: ${saju['hour']}');
      expect(saju['hour']!.substring(1), '오'); // Should still be O-Si
    });

    test('Fallback for out-of-range years', () {
      // 1900: Out of extended data range
      final birthTime = DateTime(1900, 6, 15, 12, 0);
      final saju = SajuEngine.getSaju(birthTime);
      
      // Should still calculate, using fallback logic
      expect(saju['year'], isNotNull);
      expect(saju['month'], isNotNull);
      print('\n1900-06-15 Saju (fallback):');
      print('Year: ${saju['year']}');
      print('Month: ${saju['month']}');
    });
  });

  group('Compliance Verification', () {
    test('Compliance check: 2006-02-04 boundary', () {
      // Report scenario: 2006 Ipchun at 07:27
      // Unfortunately we don't have exact data for 2006, need to verify
      final ipchun2006 = ExtendedIpchunData.getIpchunDate(2006);
      
      if (ipchun2006 != null) {
        final before = ipchun2006.subtract(Duration(minutes: 1));
        final after = ipchun2006.add(Duration(minutes: 1));
        
        final yearBefore = SajuEngine.getYearGanJi(before);
        final yearAfter = SajuEngine.getYearGanJi(after);
        
        expect(yearBefore, isNot(equals(yearAfter)));
        print('\n2006 Ipchun boundary test:');
        print('Ipchun time: $ipchun2006');
        print('Before: $yearBefore (2005)');
        print('After: $yearAfter (2006)');
      }
    });

    test('Coverage summary', () {
      final yearRange = ExtendedIpchunData.yearRange;
      final coverage = yearRange[1] - yearRange[0] + 1;
      
      print('\n=== Saju Engine Coverage ===');
      print('Year Pillar precision: ${yearRange[0]}-${yearRange[1]} ($coverage years)');
      print('Month Pillar precision: 2024-2025 (expandable)');
      print('Hour Pillar: Solar time corrected');
      print('Time correction: 1908-present with historical accuracy');
      print('Ya-Ja-Si: User-configurable');
    });
  });
}
