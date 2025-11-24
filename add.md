🔮 사주 운세 엔진 고도화 기술 명세서 (Roadmap)
1. 개요 (Overview)
목표: 천문학적 데이터를 단순 나열하는 단계를 넘어, 글자 간의 관계(십성, 합충, 신살)를 분석하여 사용자의 길흉화복을 판단하는 알고리즘 구현.

대상 파일: lib/core/utils/saju_engine.dart (확장), lib/data/models/saju_analysis.dart (신규 생성 필요)

2. 단계별 구현 상세 (Implementation Steps)
[Step 1] 기초 관계성 정립: 십성(Ten Gods) 및 12운성
가장 기초적인 해석의 언어인 '십성(육친)'과 에너지의 세기를 나타내는 '12운성'을 구현합니다.

기능 정의:

십성(Ten Gods): 일간(나)과 다른 글자와의 생극제화 관계 (비견, 겁재, 식신, 상관, 편재, 정재, 편관, 정관, 편인, 정인).

12운성(Twelve Stages): 천간이 지지에서 갖는 힘의 세기 (장생, 목욕, 관대 ... 절, 태, 양).

구현 로직 예시 (Dart):

Dart

enum TenGod {
  biGyeon, // 비견 (나와 같은 오행, 음양 같음)
  geopJae, // 겁재 (나와 같은 오행, 음양 다름)
  sikSin,  // 식신 (내가 생함, 음양 같음)
  sangGwan,// 상관 (내가 생함, 음양 다름)
  // ... 나머지 6개
}

// SajuEngine 클래스 확장
static TenGod getTenGod(String dayGan, String target) {
  // 1. dayGan과 target의 오행 비교
  // 2. dayGan과 target의 음양 비교
  // 3. 매트릭스에 따라 TenGod 반환
}
[Step 2] 동적 상호작용: 합(合)·충(沖)·형(刑) 알고리즘
사주 원국 내 글자끼리의 화학 작용을 계산합니다. 이는 운세의 좋고 나쁨을 결정하는 핵심 변수입니다.

구현 목록:

천간합(Heavenly Stems Combination): 갑기합(토), 을경합(금) 등 5쌍.

천간충(Heavenly Stems Clash): 갑경충, 을신충 등.

지지육합(Six Combinations): 자축합, 인해합 등.

지지삼합(Three Harmony): 신자진(수국), 인오술(화국) 등 → 오행의 변화를 계산해야 함.

지지충/형: 자오충, 인사신 삼형살 등.

데이터 구조 설계:

단순 Boolean 체크가 아니라, List<InteractionResult> 형태로 반환하여 "어떤 글자와 어떤 글자가 충돌했는지" 정보를 UI에 전달해야 합니다.

[Step 3] 시간의 흐름: 대운(大運) 및 세운(歲運) 계산
현재 엔진은 getSaju(DateTime date)를 통해 정적인 4기둥만 뽑습니다. 10년마다 변하는 운(대운)을 계산해야 인생 그래프를 그릴 수 있습니다.

알고리즘 순서:

대운수(Age) 계산: 태어난 날짜와 가장 가까운 절기(입춘, 입하 등)까지의 날짜 수 ÷ 3.

순행/역행 판단:

양남음녀(양의 해 남자, 음의 해 여자) → 순행 (월주 다음 글자부터 시작)

음남양녀(음의 해 남자, 양의 해 여자) → 역행 (월주 이전 글자부터 거꾸로)

대운 리스트 생성: 10년 단위의 간지(Gan-Ji) 리스트 생성.

[Step 4] 종합 판단: 용신(用神) 및 점수화 (Scoring)
사용자에게 "85점"과 같은 직관적인 결과를 주기 위한 내부 평가 로직입니다. 가장 난이도가 높습니다.

평가 로직 (억부법 기준 Simplified):

세력 점수화: 사주 8글자의 오행별 점수 계산 (예: 월지는 30점, 일지는 15점 등 가중치 부여).

신강/신약 판단: 나를 도와주는 세력(인성+비겁) vs 힘을 빼는 세력(식상+재성+관성) 비교.

용신(Lucky Element) 선정:

신약하면 → 인성/비겁이 용신 (Lucky)

신강하면 → 식상/재성/관성이 용신 (Lucky)

오늘의 운세 매칭:

오늘의 오행 == 용신 오행 → "매우 좋음 (90점+)"

오늘의 오행 == 기신(Bad) 오행 → "주의 필요 (50점-)"

3. 추천 파일 구조 (Refactoring Plan)
기존 코드를 유지하면서 기능을 확장하기 위한 폴더 구조 제안입니다.

Plaintext

lib/
├── core/
│   └── utils/
│       ├── saju_engine.dart      // [기존] 만세력 산출 (천문 계산)
│       └── saju_converter.dart   // [신규] 음양오행 변환 유틸 (오행 색상, 숫자 등)
├── features/
│   └── saju_analyzer/            // [신규] 해석 엔진 패키지
│       ├── models/
│       │   ├── ten_gods.dart     // 십성 Enum
│       │   ├── twelve_stages.dart// 12운성 Enum
🔮 사주 운세 엔진 고도화 기술 명세서 (Roadmap)
1. 개요 (Overview)
목표: 천문학적 데이터를 단순 나열하는 단계를 넘어, 글자 간의 관계(십성, 합충, 신살)를 분석하여 사용자의 길흉화복을 판단하는 알고리즘 구현.

대상 파일: lib/core/utils/saju_engine.dart (확장), lib/data/models/saju_analysis.dart (신규 생성 필요)

2. 단계별 구현 상세 (Implementation Steps)
[Step 1] 기초 관계성 정립: 십성(Ten Gods) 및 12운성
가장 기초적인 해석의 언어인 '십성(육친)'과 에너지의 세기를 나타내는 '12운성'을 구현합니다.

기능 정의:

십성(Ten Gods): 일간(나)과 다른 글자와의 생극제화 관계 (비견, 겁재, 식신, 상관, 편재, 정재, 편관, 정관, 편인, 정인).

12운성(Twelve Stages): 천간이 지지에서 갖는 힘의 세기 (장생, 목욕, 관대 ... 절, 태, 양).

구현 로직 예시 (Dart):

Dart

enum TenGod {
  biGyeon, // 비견 (나와 같은 오행, 음양 같음)
  geopJae, // 겁재 (나와 같은 오행, 음양 다름)
  sikSin,  // 식신 (내가 생함, 음양 같음)
  sangGwan,// 상관 (내가 생함, 음양 다름)
  // ... 나머지 6개
}

// SajuEngine 클래스 확장
static TenGod getTenGod(String dayGan, String target) {
  // 1. dayGan과 target의 오행 비교
  // 2. dayGan과 target의 음양 비교
  // 3. 매트릭스에 따라 TenGod 반환
}
[Step 2] 동적 상호작용: 합(合)·충(沖)·형(刑) 알고리즘
사주 원국 내 글자끼리의 화학 작용을 계산합니다. 이는 운세의 좋고 나쁨을 결정하는 핵심 변수입니다.

구현 목록:

천간합(Heavenly Stems Combination): 갑기합(토), 을경합(금) 등 5쌍.

천간충(Heavenly Stems Clash): 갑경충, 을신충 등.

지지육합(Six Combinations): 자축합, 인해합 등.

지지삼합(Three Harmony): 신자진(수국), 인오술(화국) 등 → 오행의 변화를 계산해야 함.

지지충/형: 자오충, 인사신 삼형살 등.

데이터 구조 설계:

단순 Boolean 체크가 아니라, List<InteractionResult> 형태로 반환하여 "어떤 글자와 어떤 글자가 충돌했는지" 정보를 UI에 전달해야 합니다.

[Step 3] 시간의 흐름: 대운(大運) 및 세운(歲運) 계산
현재 엔진은 getSaju(DateTime date)를 통해 정적인 4기둥만 뽑습니다. 10년마다 변하는 운(대운)을 계산해야 인생 그래프를 그릴 수 있습니다.

알고리즘 순서:

대운수(Age) 계산: 태어난 날짜와 가장 가까운 절기(입춘, 입하 등)까지의 날짜 수 ÷ 3.

순행/역행 판단:

양남음녀(양의 해 남자, 음의 해 여자) → 순행 (월주 다음 글자부터 시작)

음남양녀(음의 해 남자, 양의 해 여자) → 역행 (월주 이전 글자부터 거꾸로)

대운 리스트 생성: 10년 단위의 간지(Gan-Ji) 리스트 생성.

[Step 4] 종합 판단: 용신(用神) 및 점수화 (Scoring)
사용자에게 "85점"과 같은 직관적인 결과를 주기 위한 내부 평가 로직입니다. 가장 난이도가 높습니다.

평가 로직 (억부법 기준 Simplified):

세력 점수화: 사주 8글자의 오행별 점수 계산 (예: 월지는 30점, 일지는 15점 등 가중치 부여).

신강/신약 판단: 나를 도와주는 세력(인성+비겁) vs 힘을 빼는 세력(식상+재성+관성) 비교.

용신(Lucky Element) 선정:

신약하면 → 인성/비겁이 용신 (Lucky)

신강하면 → 식상/재성/관성이 용신 (Lucky)

오늘의 운세 매칭:

오늘의 오행 == 용신 오행 → "매우 좋음 (90점+)"

오늘의 오행 == 기신(Bad) 오행 → "주의 필요 (50점-)"

3. 추천 파일 구조 (Refactoring Plan)
기존 코드를 유지하면서 기능을 확장하기 위한 폴더 구조 제안입니다.

Plaintext

lib/
├── core/
│   └── utils/
│       ├── saju_engine.dart      // [기존] 만세력 산출 (천문 계산)
│       └── saju_converter.dart   // [신규] 음양오행 변환 유틸 (오행 색상, 숫자 등)
├── features/
│   └── saju_analyzer/            // [신규] 해석 엔진 패키지
│       ├── models/
│       │   ├── ten_gods.dart     // 십성 Enum
│       │   ├── twelve_stages.dart// 12운성 Enum
│       │   └── interactions.dart // 합충형파해 결과 모델
12운성(Twelve Stages): 천간이 지지에서 갖는 힘의 세기 (장생, 목욕, 관대 ... 절, 태, 양).

구현 로직 예시 (Dart):

Dart

enum TenGod {
  biGyeon, // 비견 (나와 같은 오행, 음양 같음)
  geopJae, // 겁재 (나와 같은 오행, 음양 다름)
  sikSin,  // 식신 (내가 생함, 음양 같음)
  sangGwan,// 상관 (내가 생함, 음양 다름)
  // ... 나머지 6개
}

// SajuEngine 클래스 확장
static TenGod getTenGod(String dayGan, String target) {
  // 1. dayGan과 target의 오행 비교
  // 2. dayGan과 target의 음양 비교
  // 3. 매트릭스에 따라 TenGod 반환
}
[Step 2] 동적 상호작용: 합(合)·충(沖)·형(刑) 알고리즘
사주 원국 내 글자끼리의 화학 작용을 계산합니다. 이는 운세의 좋고 나쁨을 결정하는 핵심 변수입니다.

구현 목록:

천간합(Heavenly Stems Combination): 갑기합(토), 을경합(금) 등 5쌍.

천간충(Heavenly Stems Clash): 갑경충, 을신충 등.

지지육합(Six Combinations): 자축합, 인해합 등.

지지삼합(Three Harmony): 신자진(수국), 인오술(화국) 등 → 오행의 변화를 계산해야 함.

지지충/형: 자오충, 인사신 삼형살 등.

데이터 구조 설계:

단순 Boolean 체크가 아니라, List<InteractionResult> 형태로 반환하여 "어떤 글자와 어떤 글자가 충돌했는지" 정보를 UI에 전달해야 합니다.

[Step 3] 시간의 흐름: 대운(大運) 및 세운(歲運) 계산
현재 엔진은 getSaju(DateTime date)를 통해 정적인 4기둥만 뽑습니다. 10년마다 변하는 운(대운)을 계산해야 인생 그래프를 그릴 수 있습니다.

알고리즘 순서:

대운수(Age) 계산: 태어난 날짜와 가장 가까운 절기(입춘, 입하 등)까지의 날짜 수 ÷ 3.

순행/역행 판단:

양남음녀(양의 해 남자, 음의 해 여자) → 순행 (월주 다음 글자부터 시작)

음남양녀(음의 해 남자, 양의 해 여자) → 역행 (월주 이전 글자부터 거꾸로)

대운 리스트 생성: 10년 단위의 간지(Gan-Ji) 리스트 생성.

[Step 4] 종합 판단: 용신(用神) 및 점수화 (Scoring)
사용자에게 "85점"과 같은 직관적인 결과를 주기 위한 내부 평가 로직입니다. 가장 난이도가 높습니다.

평가 로직 (억부법 기준 Simplified):

세력 점수화: 사주 8글자의 오행별 점수 계산 (예: 월지는 30점, 일지는 15점 등 가중치 부여).

신강/신약 판단: 나를 도와주는 세력(인성+비겁) vs 힘을 빼는 세력(식상+재성+관성) 비교.

용신(Lucky Element) 선정:

신약하면 → 인성/비겁이 용신 (Lucky)

신강하면 → 식상/재성/관성이 용신 (Lucky)

오늘의 운세 매칭:

오늘의 오행 == 용신 오행 → "매우 좋음 (90점+)"

오늘의 오행 == 기신(Bad) 오행 → "주의 필요 (50점-)"

3. 추천 파일 구조 (Refactoring Plan)
기존 코드를 유지하면서 기능을 확장하기 위한 폴더 구조 제안입니다.

Plaintext

lib/
├── core/
│   └── utils/
│       ├── saju_engine.dart      // [기존] 만세력 산출 (천문 계산)
│       └── saju_converter.dart   // [신규] 음양오행 변환 유틸 (오행 색상, 숫자 등)
├── features/
│   └── saju_analyzer/            // [신규] 해석 엔진 패키지
│       ├── models/
│       │   ├── ten_gods.dart     // 십성 Enum
│       │   ├── twelve_stages.dart// 12운성 Enum
🔮 사주 운세 엔진 고도화 기술 명세서 (Roadmap)
1. 개요 (Overview)
목표: 천문학적 데이터를 단순 나열하는 단계를 넘어, 글자 간의 관계(십성, 합충, 신살)를 분석하여 사용자의 길흉화복을 판단하는 알고리즘 구현.

대상 파일: lib/core/utils/saju_engine.dart (확장), lib/data/models/saju_analysis.dart (신규 생성 필요)

2. 단계별 구현 상세 (Implementation Steps)
[Step 1] 기초 관계성 정립: 십성(Ten Gods) 및 12운성
가장 기초적인 해석의 언어인 '십성(육친)'과 에너지의 세기를 나타내는 '12운성'을 구현합니다.

기능 정의:

십성(Ten Gods): 일간(나)과 다른 글자와의 생극제화 관계 (비견, 겁재, 식신, 상관, 편재, 정재, 편관, 정관, 편인, 정인).

12운성(Twelve Stages): 천간이 지지에서 갖는 힘의 세기 (장생, 목욕, 관대 ... 절, 태, 양).

구현 로직 예시 (Dart):

Dart

enum TenGod {
  biGyeon, // 비견 (나와 같은 오행, 음양 같음)
  geopJae, // 겁재 (나와 같은 오행, 음양 다름)
  sikSin,  // 식신 (내가 생함, 음양 같음)
  sangGwan,// 상관 (내가 생함, 음양 다름)
  // ... 나머지 6개
}

// SajuEngine 클래스 확장
static TenGod getTenGod(String dayGan, String target) {
  // 1. dayGan과 target의 오행 비교
  // 2. dayGan과 target의 음양 비교
  // 3. 매트릭스에 따라 TenGod 반환
}
[Step 2] 동적 상호작용: 합(合)·충(沖)·형(刑) 알고리즘
사주 원국 내 글자끼리의 화학 작용을 계산합니다. 이는 운세의 좋고 나쁨을 결정하는 핵심 변수입니다.

구현 목록:

천간합(Heavenly Stems Combination): 갑기합(토), 을경합(금) 등 5쌍.

천간충(Heavenly Stems Clash): 갑경충, 을신충 등.

지지육합(Six Combinations): 자축합, 인해합 등.

지지삼합(Three Harmony): 신자진(수국), 인오술(화국) 등 → 오행의 변화를 계산해야 함.

지지충/형: 자오충, 인사신 삼형살 등.

데이터 구조 설계:

단순 Boolean 체크가 아니라, List<InteractionResult> 형태로 반환하여 "어떤 글자와 어떤 글자가 충돌했는지" 정보를 UI에 전달해야 합니다.

[Step 3] 시간의 흐름: 대운(大運) 및 세운(歲運) 계산
현재 엔진은 getSaju(DateTime date)를 통해 정적인 4기둥만 뽑습니다. 10년마다 변하는 운(대운)을 계산해야 인생 그래프를 그릴 수 있습니다.

알고리즘 순서:

대운수(Age) 계산: 태어난 날짜와 가장 가까운 절기(입춘, 입하 등)까지의 날짜 수 ÷ 3.

순행/역행 판단:

양남음녀(양의 해 남자, 음의 해 여자) → 순행 (월주 다음 글자부터 시작)

음남양녀(음의 해 남자, 양의 해 여자) → 역행 (월주 이전 글자부터 거꾸로)

대운 리스트 생성: 10년 단위의 간지(Gan-Ji) 리스트 생성.

[Step 4] 종합 판단: 용신(用神) 및 점수화 (Scoring)
사용자에게 "85점"과 같은 직관적인 결과를 주기 위한 내부 평가 로직입니다. 가장 난이도가 높습니다.

평가 로직 (억부법 기준 Simplified):

세력 점수화: 사주 8글자의 오행별 점수 계산 (예: 월지는 30점, 일지는 15점 등 가중치 부여).

신강/신약 판단: 나를 도와주는 세력(인성+비겁) vs 힘을 빼는 세력(식상+재성+관성) 비교.

용신(Lucky Element) 선정:

신약하면 → 인성/비겁이 용신 (Lucky)

신강하면 → 식상/재성/관성이 용신 (Lucky)

오늘의 운세 매칭:

오늘의 오행 == 용신 오행 → "매우 좋음 (90점+)"

오늘의 오행 == 기신(Bad) 오행 → "주의 필요 (50점-)"

3. 추천 파일 구조 (Refactoring Plan)
기존 코드를 유지하면서 기능을 확장하기 위한 폴더 구조 제안입니다.

Plaintext

lib/
├── core/
│   └── utils/
│       ├── saju_engine.dart      // [기존] 만세력 산출 (천문 계산)
│       └── saju_converter.dart   // [신규] 음양오행 변환 유틸 (오행 색상, 숫자 등)
├── features/
│   └── saju_analyzer/            // [신규] 해석 엔진 패키지
│       ├── models/
│       │   ├── ten_gods.dart     // 십성 Enum
│       │   ├── twelve_stages.dart// 12운성 Enum
│       │   └── interactions.dart // 합충형파해 결과 모델
│       ├── logic/
│       │   ├── interaction_calculator.dart // 합/충 계산 로직
│       │   ├── daeun_calculator.dart       // 대운 계산 로직
│       │   └── yongsin_selector.dart       // 용신/희신 판단 로직
│       └── saju_service.dart     // UI에서 호출하는 Facade 서비스
4. 개발 체크리스트 (To-Do)
Phase 1: 데이터 모델링

[x] TenGod (십성) Enum 정의 및 산출 로직 구현.

[x] TwelveStage (12운성) 표 매핑 로직 구현.

Phase 2: 관계성 구현

[x] 천간 합/충 로직 구현 (List 반환).

[x] 지지 삼합/방합/육합/충/형 로직 구현.

Phase 3: 대운(Life Cycle) 구현
}
[Step 2] 동적 상호작용: 합(合)·충(沖)·형(刑) 알고리즘
사주 원국 내 글자끼리의 화학 작용을 계산합니다. 이는 운세의 좋고 나쁨을 결정하는 핵심 변수입니다.

구현 목록:

천간합(Heavenly Stems Combination): 갑기합(토), 을경합(금) 등 5쌍.

천간충(Heavenly Stems Clash): 갑경충, 을신충 등.

지지육합(Six Combinations): 자축합, 인해합 등.

지지삼합(Three Harmony): 신자진(수국), 인오술(화국) 등 → 오행의 변화를 계산해야 함.

지지충/형: 자오충, 인사신 삼형살 등.

데이터 구조 설계:

단순 Boolean 체크가 아니라, List<InteractionResult> 형태로 반환하여 "어떤 글자와 어떤 글자가 충돌했는지" 정보를 UI에 전달해야 합니다.

[Step 3] 시간의 흐름: 대운(大運) 및 세운(歲運) 계산
현재 엔진은 getSaju(DateTime date)를 통해 정적인 4기둥만 뽑습니다. 10년마다 변하는 운(대운)을 계산해야 인생 그래프를 그릴 수 있습니다.

알고리즘 순서:

대운수(Age) 계산: 태어난 날짜와 가장 가까운 절기(입춘, 입하 등)까지의 날짜 수 ÷ 3.

순행/역행 판단:

양남음녀(양의 해 남자, 음의 해 여자) → 순행 (월주 다음 글자부터 시작)

음남양녀(음의 해 남자, 양의 해 여자) → 역행 (월주 이전 글자부터 거꾸로)

대운 리스트 생성: 10년 단위의 간지(Gan-Ji) 리스트 생성.

[Step 4] 종합 판단: 용신(用神) 및 점수화 (Scoring)
사용자에게 "85점"과 같은 직관적인 결과를 주기 위한 내부 평가 로직입니다. 가장 난이도가 높습니다.

평가 로직 (억부법 기준 Simplified):

세력 점수화: 사주 8글자의 오행별 점수 계산 (예: 월지는 30점, 일지는 15점 등 가중치 부여).

신강/신약 판단: 나를 도와주는 세력(인성+비겁) vs 힘을 빼는 세력(식상+재성+관성) 비교.

용신(Lucky Element) 선정:

신약하면 → 인성/비겁이 용신 (Lucky)

신강하면 → 식상/재성/관성이 용신 (Lucky)

오늘의 운세 매칭:

오늘의 오행 == 용신 오행 → "매우 좋음 (90점+)"

오늘의 오행 == 기신(Bad) 오행 → "주의 필요 (50점-)"

3. 추천 파일 구조 (Refactoring Plan)
기존 코드를 유지하면서 기능을 확장하기 위한 폴더 구조 제안입니다.

Plaintext

lib/
├── core/
│   └── utils/
│       ├── saju_engine.dart      // [기존] 만세력 산출 (천문 계산)
│       └── saju_converter.dart   // [신규] 음양오행 변환 유틸 (오행 색상, 숫자 등)
├── features/
│   └── saju_analyzer/            // [신규] 해석 엔진 패키지
│       ├── models/
│       │   ├── ten_gods.dart     // 십성 Enum
│       │   ├── twelve_stages.dart// 12운성 Enum
│       │   └── interactions.dart // 합충형파해 결과 모델
│       ├── logic/
│       │   ├── interaction_calculator.dart // 합/충 계산 로직
│       │   ├── daeun_calculator.dart       // 대운 계산 로직
│       │   └── yongsin_selector.dart       // 용신/희신 판단 로직
│       └── saju_service.dart     // UI에서 호출하는 Facade 서비스
4. 개발 체크리스트 (To-Do)
Phase 1: 데이터 모델링

[x] TenGod (십성) Enum 정의 및 산출 로직 구현.

[x] TwelveStage (12운성) 표 매핑 로직 구현.

Phase 2: 관계성 구현

[x] 천간 합/충 로직 구현 (List 반환).

[x] 지지 삼합/방합/육합/충/형 로직 구현.

Phase 3: 대운(Life Cycle) 구현

[x] 성별(남/녀) 정보 입력을 받는 로직 추가 (필수).

[x] 대운수(숫자) 및 대운 간지 리스트 산출 함수 작성.

Phase 4: 운세 알고리즘 고도화

[x] 현재 FortuneCalendarService의 랜덤 기반 로직(dayHash)을 제거.

[x] [용신 찾기] -> [오늘 날짜와 비교] -> [점수 산출] 로직으로 전면 교체.

## ✅ 모든 Phase 완료!