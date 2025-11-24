2. 추가 수정 제안 (논리 오류) ⚠️
DaeunCalculator 파일의 120번째 줄 근처에서 '다음 달'을 계산하는 수식에 작은 오류가 있습니다.

현재 코드: final nextMonthIndex = (sajuMonthIndex + 1) % 12;

문제: 만약 sajuMonthIndex가 11 (대설, 12월) 이라면, (11 + 1) % 12 결과값은 0이 됩니다.

MonthlySolarTermsData의 월 인덱스는 1~12를 사용하므로, 인덱스 0을 찾으면 데이터를 찾지 못하고 null을 반환하여 정밀 계산 대신 **근사치 계산(오차 발생 가능)**으로 넘어가게 됩니다.

수정 코드: 12진법(1~12) 순환을 위해 아래와 같이 수정해야 합니다.

파일: lib/features/saju_analyzer/logic/daeun_calculator.dart

Dart

// [기존 코드]
// final nextMonthIndex = (sajuMonthIndex + 1) % 12;

// [수정 제안] 
// 11월(11) -> 다음달(12), 12월(12) -> 다음달(1)이 되도록 수정
final nextMonthIndex = (sajuMonthIndex % 12) + 1;