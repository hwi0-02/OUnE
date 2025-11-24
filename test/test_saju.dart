import 'package:flutter_test/flutter_test.dart';
import 'package:app_project/core/utils/saju_engine.dart';

void main() {
  test('SajuEngine calculates GanJi correctly', () {
    final now = DateTime.now();
    print('Year: ${SajuEngine.getYearGanJi(now)}');
    print('Month: ${SajuEngine.getMonthGanJi(now)}');
    print('Day: ${SajuEngine.getDayGanJi(now)}');
    
    final ohaeng = SajuEngine.getOhaeng('갑');
    expect(ohaeng, '목');
  });
}
