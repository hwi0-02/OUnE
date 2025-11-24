import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/services/fortune_service.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:app_project/core/providers/saju_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedFortuneScreen extends ConsumerStatefulWidget {
  const DetailedFortuneScreen({super.key});

  @override
  ConsumerState<DetailedFortuneScreen> createState() => _DetailedFortuneScreenState();
}

class _DetailedFortuneScreenState extends ConsumerState<DetailedFortuneScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger Saju analysis when user has complete data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userAsync = ref.read(userProvider);
      userAsync.whenData((user) {
        if (user != null && user.hasCompleteSajuData) {
          ref.read(sajuAnalysisProvider.notifier).analyzeUser(user);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 운세'),
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
            return const Center(
              child: Text('로그인이 필요합니다.', style: TextStyle(color: Colors.white)),
            );
          }

          final detailedFortune = FortuneService().getDetailedFortune(user, DateTime.now());
          final dailyScore = ref.watch(dailyFortuneProvider(DateTime.now()));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                  user.hasCompleteSajuData
                      ? '사주 기반 맞춤 운세입니다 ✨'
                      : '일반 운세 (정확한 분석을 위해 생년월일시를 등록하세요)',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 24),

                // Overall Score Card (if Saju data available)
                if (user.hasCompleteSajuData && dailyScore != null)
                  _buildOverallScoreCard(dailyScore),
                
                if (user.hasCompleteSajuData && dailyScore != null)
                  const SizedBox(height: 24),

                // Fortune sections
                _buildFortuneCard(
                  '💕 연애운',
                  detailedFortune['love']!['score'],
                  detailedFortune['love']!['content'],
                  AppTheme.primaryPink,
                ),
                const SizedBox(height: 16),

                _buildFortuneCard(
                  '💰 재물운',
                  detailedFortune['money']!['score'],
                  detailedFortune['money']!['content'],
                  AppTheme.pointGold,
                ),
                const SizedBox(height: 16),

                _buildFortuneCard(
                  '💼 직장운',
                  detailedFortune['work']!['score'],
                  detailedFortune['work']!['content'],
                  AppTheme.secondaryBlue,
                ),
                const SizedBox(height: 16),

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
        error: (_, __) => const Center(
          child: Text('에러가 발생했습니다.', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(int score) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary,
            AppTheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            '오늘의 종합 운세',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$score점',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getScoreText(score),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreText(int score) {
    if (score >= 85) return '매우 좋은 날입니다!';
    if (score >= 70) return '좋은 하루가 되겠습니다';
    if (score >= 50) return '평범한 하루입니다';
    if (score >= 30) return '조심스러운 하루입니다';
    return '중요한 일은 미루는 것이 좋겠습니다';
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
