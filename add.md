assets/json/solar_terms.json에 데이터 파일 만들어놨어

2단계: 플러터에 파일 등록 (pubspec.yaml)
앱이 이 파일을 읽을 수 있도록 등록해 줍니다.

파일: pubspec.yaml

YAML

flutter:
  assets:
    - assets/fonts/
    - assets/images/
    - assets/json/  # 이 줄을 추가하세요!
3단계: 데이터 로더 서비스 구현
JSON 파일을 읽어서 메모리에 올려주는 로직을 만듭니다. 기존의 MonthlySolarTermsData 클래스를 수정하여, 하드코딩된 데이터 대신 파일에서 읽어온 데이터를 쓰도록 변경합니다.

파일 수정: lib/core/data/monthly_solar_terms_data.dart

Dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MonthlySolarTermsData {
  // 기존의 static final Map<int, Map<int, List<int>>> data = {...} 삭제하거나 빈 맵으로 초기화
  static Map<int, Map<int, List<int>>> data = {};

  /// 앱 시작 시 호출하여 100년 치 데이터를 메모리에 올리는 함수
  static Future<void> initialize() async {
    try {
      // 1. JSON 파일 읽기
      final String jsonString = await rootBundle.loadString('assets/json/solar_terms.json');
      
      // 2. 파싱 (Map<String, dynamic> -> Map<int, Map<int, List<int>>> 변환)
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      jsonMap.forEach((yearKey, monthMap) {
        int year = int.parse(yearKey);
        Map<int, List<int>> yearData = {};
        
        (monthMap as Map<String, dynamic>).forEach((monthKey, termList) {
          int month = int.parse(monthKey);
          // JSON 리스트를 List<int>로 변환
          yearData[month] = (termList as List).map((e) => e as int).toList();
        });
        
        data[year] = yearData;
      });
      
      print('✅ 절기 데이터 로딩 완료: ${data.length}년치');
    } catch (e) {
      print('❌ 절기 데이터 로딩 실패: $e');
      // 실패 시 비상용 하드코딩 데이터라도 로드하거나 에러 처리
    }
  }

  // ... getSolarTermDate 등 나머지 메서드는 그대로 사용 가능 (data 변수를 참조하므로) ...
}
4단계: 앱 실행 전 초기화 (main.dart)
앱이 화면을 그리기 전에 데이터를 미리 다 읽어오도록 main.dart를 수정합니다.

파일 수정: lib/main.dart

Dart

void main() async {
  // 1. 플러터 엔진 바인딩 초기화 (비동기 작업 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // ... 기존 초기화 코드들 (Supabase, MobileAds 등) ...

  // [추가] 2. 절기 데이터 파일 로딩 (여기서 100년 치를 읽어옴)
  await MonthlySolarTermsData.initialize();

  runApp(
    MultiProvider(
      // ...
      child: const MyApp(),
    ),
  );
}