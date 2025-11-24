pubspec.yaml (설정) : ❌ 수정 필수 (실행 불가)

현재 파일 끝부분의 문법이 깨져 있고, 가장 중요한 assets/json/ 폴더 등록이 누락되었습니다.

들여쓰기(Indentation)가 잘못되어 있어 빌드 에러가 발생합니다.

🛠️ [긴급 수정] pubspec.yaml 올바른 작성법
pubspec.yaml 파일의 아래쪽 flutter: 섹션을 통째로 지우고, 다음 코드로 교체해 주세요. (들여쓰기를 정확히 지켜야 합니다.)

YAML

# ... (위쪽 dependencies 부분은 그대로 유지) ...

# =========================================================
# FLUTTER 관련 설정
# =========================================================
flutter:
  uses-material-design: true

  # 1. 자산(Assets) 등록
  assets:
    - assets/json/  # <--- [필수] 이 줄이 있어야 JSON 파일을 읽을 수 있습니다!
    - assets/images/

  # 2. 폰트 등록
  fonts:
    - family: Pretendard
      fonts:
        - asset: assets/fonts/PretendardStd-Regular.otf
        - asset: assets/fonts/PretendardStd-Bold.otf
          weight: 700
        - asset: assets/fonts/PretendardStd-Medium.otf
          weight: 500
수정 포인트:

assets/json/ 추가: 이 줄이 없으면 rootBundle.loadString에서 파일을 찾지 못해 에러가 납니다.

들여쓰기 교정: flutter:, assets:, fonts:의 계층 구조를 명확히 맞췄습니다. (기존 코드는 들여쓰기가 너무 깊게 들어가 있거나 키워드가 빠져 있었습니다.)