import 'package:app_project/core/theme/app_theme.dart';
import 'package:app_project/data/services/tojeong_database.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 신년운세 및 토정비결 화면
class YearlyFortuneScreen extends ConsumerStatefulWidget {
  const YearlyFortuneScreen({super.key});

  @override
  ConsumerState<YearlyFortuneScreen> createState() => _YearlyFortuneScreenState();
}

class _YearlyFortuneScreenState extends ConsumerState<YearlyFortuneScreen> {
  int _selectedYear = DateTime.now().year;
  TojeongHexagram? _hexagram;

  @override
  void initState() {
    super.initState();
    _calculateFortune();
  }

  void _calculateFortune() {
    final userState = ref.read(userProvider);
    userState.whenData((userData) {
      if (userData != null) {
        final hexagramNumber = TojeongDatabase.calculateHexagramNumber(
          birthDate: userData.birthDate,
          targetYear: _selectedYear,
        );
        setState(() {
          _hexagram = TojeongDatabase.getHexagram(hexagramNumber);
        });
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('신년운세 & 토정비결'),
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: userState.when(
        data: (userData) {
          if (userData == null) {
            return const Center(child: Text('사용자 정보를 불러올 수 없습니다.', style: TextStyle(color: Colors.white)));
          }
          return _buildFortuneContent();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류: $error', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildFortuneContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 연도 선택
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '운세를 볼 연도:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear--;
                          _calculateFortune();
                        });
                      },
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_selectedYear년',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear++;
                          _calculateFortune();
                        });
                      },
                      icon: const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 오운이 인사
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPink.withOpacity(0.2),
                  AppTheme.secondaryBlue.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primaryPink,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '"$_selectedYear년, 오운이가 한 해 운세를 알려줄게! ♡"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 토정비결 결과
          if (_hexagram != null) ...[
            // 괘 제목
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.pointGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.pointGold.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '📜 토정비결',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.pointGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hexagram!.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 전반적인 운세
            _buildSection(
              title: '🌟 전반적인 운세',
              content: _hexagram!.fortune,
              color: AppTheme.primaryPink,
            ),
            const SizedBox(height: 12),

            // 주의사항
            _buildSection(
              title: '⚠️ 주의사항',
              content: _hexagram!.warning,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),

            // 조언
            _buildSection(
              title: '💡 오운이의 조언',
              content: _hexagram!.advice,
              color: AppTheme.secondaryBlue,
            ),
            const SizedBox(height: 24),

            // 공유 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('공유 기능은 준비 중입니다')),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('친구에게 공유하기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
