import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/services/fortune_service.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedFortuneScreen extends ConsumerWidget {
  const DetailedFortuneScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('세부 운세'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('로그인이 필요합니다.', style: TextStyle(color: Colors.white)));
          }

          final detailedFortune = FortuneService().getDetailedFortune(user, DateTime.now());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 세부 운세',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '각 분야의 운세를 상세히 확인해보세요',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 32),

                // Love Fortune
                _buildFortuneCard(
                  '💕 연애운',
                  detailedFortune['love']!['score'],
                  detailedFortune['love']!['content'],
                  AppTheme.primaryPink,
                ),
                const SizedBox(height: 16),

                // Money Fortune
                _buildFortuneCard(
                  '💰 재물운',
                  detailedFortune['money']!['score'],
                  detailedFortune['money']!['content'],
                  AppTheme.pointGold,
                ),
                const SizedBox(height: 16),

                // Work Fortune
                _buildFortuneCard(
                  '💼 직장운',
                  detailedFortune['work']!['score'],
                  detailedFortune['work']!['content'],
                  AppTheme.secondaryBlue,
                ),
                const SizedBox(height: 16),

                // Health Fortune
                _buildFortuneCard(
                  '💪 건강운',
                  detailedFortune['health']!['score'],
                  detailedFortune['health']!['content'],
                  Colors.green,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('에러가 발생했습니다.', style: TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildFortuneCard(String title, int score, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    final starScore = score / 20;
                    if (index < starScore.floor()) {
                      return Icon(Icons.star, color: color, size: 20);
                    } else if (index < starScore && starScore % 1 >= 0.5) {
                      return Icon(Icons.star_half, color: color, size: 20);
                    } else {
                      return Icon(Icons.star_border, color: color.withOpacity(0.3), size: 20);
                    }
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '$score점',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
