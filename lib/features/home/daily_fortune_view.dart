import 'dart:math';

import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/models/fortune_model.dart';
import 'package:app_project/data/services/fortune_service.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DailyFortuneView extends ConsumerStatefulWidget {
  const DailyFortuneView({super.key});

  @override
  ConsumerState<DailyFortuneView> createState() => _DailyFortuneViewState();
}

class _DailyFortuneViewState extends ConsumerState<DailyFortuneView> {
  String _greeting = "안녕! 오늘도 왔어? ♡";

  void _changeGreeting() {
    final greetings = [
      "안녕! 오늘도 왔어? ♡",
      "기다렸어! 이제 운세 볼까? ✨",
      "또 만나서 반가워! 💕",
      "오늘은 어떤 하루가 될까? 두근두근! ♡",
      "너 충분히 잘하고 있어! ♡",
      "오늘 하루도 화이팅해! 💕",
    ];
    setState(() {
      _greeting = greetings[Random().nextInt(greetings.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(now);
    final userState = ref.watch(userProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    userState.when(
                      data: (user) => Text(
                        user != null ? '${user.nickname}님 안녕하세요!' : '안녕하세요!',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      loading: () => const Text('로딩 중...', style: TextStyle(fontWeight: FontWeight.bold)),
                      error: (_, __) => const Text('안녕하세요!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Character Area
            GestureDetector(
              onTap: _changeGreeting,
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPink.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.face, size: 80, color: AppTheme.primaryPink),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _greeting,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Fortune Card
            userState.when(
              data: (user) {
                if (user == null) {
                  return const Center(child: Text('로그인이 필요합니다.'));
                }
                final fortune = FortuneService().getDailyFortune(user, now);
                return _buildFortuneCard(fortune, dateStr);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('에러 발생: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneCard(FortuneModel fortune, String dateStr) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                dateStr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '오늘의 총운',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (index) {
                    // 5 stars based on score (100 score = 5 stars)
                    final starScore = fortune.totalScore / 20;
                    if (index < starScore.floor()) {
                      return const Icon(Icons.star, color: AppTheme.pointGold);
                    } else if (index < starScore && starScore % 1 >= 0.5) {
                      return const Icon(Icons.star_half, color: AppTheme.pointGold);
                    } else {
                      return const Icon(Icons.star_border, color: AppTheme.pointGold);
                    }
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '${fortune.totalScore}점',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                fortune.content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/detailed-fortune');
                  },
                  child: const Text('세부 운세 보기'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Lucky Items
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.secondaryBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('🌈 럭키 컬러', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(fortune.luckyColor, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
              Column(
                children: [
                  const Text('🎵 럭키 넘버', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('${fortune.luckyNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
