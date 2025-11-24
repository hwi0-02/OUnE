import 'package:app_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': '오운이 운세',
      'description': '매일 만나는 나만의 운세 친구\n오운이와 함께 오늘 하루를 준비해보세요!',
      'image': 'assets/images/onboarding_1.png', // Placeholder
    },
    {
      'title': '안녕! 난 오운이야 ♡',
      'description': '전통 사주명리와 타로를 활용해서\n너의 운세를 매일 알려줄게!',
      'image': 'assets/images/onboarding_2.png', // Placeholder
    },
    {
      'title': '서비스 이용 동의',
      'description': '오운이 운세는 재미와 힐링을 위한\n엔터테인먼트 서비스예요 ♡',
      'image': 'assets/images/onboarding_3.png', // Placeholder
    },
  ];

  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _ageAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildSlide(index);
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(int index) {
    final slide = _slides[index];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Placeholder
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.image, size: 80, color: AppTheme.secondaryBlue),
          ),
          const SizedBox(height: 40),
          Text(
            slide['title']!,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            slide['description']!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: Colors.grey.shade400,
                ),
          ),
          if (index == 2) _buildAgreements(),
        ],
      ),
    );
  }

  Widget _buildAgreements() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          _buildCheckbox('이용약관 동의 (필수)', _termsAccepted, (v) => setState(() => _termsAccepted = v!)),
          _buildCheckbox('개인정보 처리방침 동의 (필수)', _privacyAccepted, (v) => setState(() => _privacyAccepted = v!)),
          _buildCheckbox('만 14세 이상입니다 (필수)', _ageAccepted, (v) => setState(() => _ageAccepted = v!)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryPink,
          side: BorderSide(color: Colors.grey.shade500),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.primaryPink
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _slides.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  if (_termsAccepted && _privacyAccepted && _ageAccepted) {
                    context.go('/profile-setup');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 약관에 동의해주세요.')),
                    );
                  }
                }
              },
              child: Text(_currentPage < _slides.length - 1 ? '다음' : '오운이 만나러 가기'),
            ),
          ),
        ],
      ),
    );
  }
}
