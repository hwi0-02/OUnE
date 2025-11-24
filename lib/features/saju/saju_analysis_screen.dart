import 'package:app_project/core/providers/saju_provider.dart';
import 'package:app_project/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/core/theme/app_theme.dart';

/// Screen showing user's detailed Saju analysis
class SajuAnalysisScreen extends ConsumerStatefulWidget {
  const SajuAnalysisScreen({super.key});

  @override
  ConsumerState<SajuAnalysisScreen> createState() => _SajuAnalysisScreenState();
}

class _SajuAnalysisScreenState extends ConsumerState<SajuAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger analysis when screen loads
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
    final userAsync = ref.watch(userProvider);
    final analysisAsync = ref.watch(sajuAnalysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 사주 분석'),
        backgroundColor: AppTheme.primary,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _buildNotLoggedIn();
          }
          if (!user.hasCompleteSajuData) {
            return _buildIncompleteData();
          }
          return analysisAsync.when(
            data: (analysis) {
              if (analysis == null) {
                return const Center(child: Text('분석 데이터 없음'));
              }
              return _buildAnalysisView(analysis, user);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('오류: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('오류: $error')),
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('로그인이 필요합니다'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to login
            },
            child: const Text('로그인하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildIncompleteData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              '생년월일시와 성별 정보가 필요합니다',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '정확한 사주 분석을 위해\n출생 시간과 성별을 등록해주세요',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to profile settings
              },
              child: const Text('정보 입력하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisView(dynamic analysis, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoCard(user),
          const SizedBox(height: 16),
          _buildFourPillarsCard(analysis),
          const SizedBox(height: 16),
          _buildStrengthCard(analysis),
          const SizedBox(height: 16),
          _buildLuckyElementCard(analysis),
          const SizedBox(height: 16),
          _buildInteractionsCard(analysis),
          const SizedBox(height: 16),
          _buildDaeunCard(analysis),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(dynamic user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.nickname ?? '사용자',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('생년월일: ${_formatDate(user.birthDate)}'),
            if (user.birthTime != null) Text('시간: ${user.birthTime}'),
            Text('성별: ${user.gender == 'male' || user.gender == '남' ? '남성' : '여성'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildFourPillarsCard(dynamic analysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '사주 팔자',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPillarColumn('년주', analysis.pillars['year']),
                _buildPillarColumn('월주', analysis.pillars['month']),
                _buildPillarColumn('일주', analysis.pillars['day']),
                _buildPillarColumn('시주', analysis.pillars['hour']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarColumn(String label, String ganji) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            ganji,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthCard(dynamic analysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '신강/신약',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              analysis.isStrong ? '신강 (强)' : '신약 (弱)',
              style: TextStyle(
                fontSize: 16,
                color: analysis.isStrong ? Colors.red : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              analysis.isStrong
                  ? '일간의 힘이 강한 사주입니다.'
                  : '일간의 힘이 약한 사주입니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuckyElementCard(dynamic analysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '용신 (Lucky Element)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              analysis.luckyElement,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getLuckyElementDescription(analysis.isStrong),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionsCard(dynamic analysis) {
    if (analysis.interactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '합충형파해',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...analysis.interactions.take(5).map<Widget>((interaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• ${interaction.description}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDaeunCard(dynamic analysis) {
    final currentDaeun = ref.watch(currentDaeunProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '대운 (10년 운)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (currentDaeun != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 대운: ${currentDaeun.ganJi}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${currentDaeun.startAge}세 ~ ${currentDaeun.endAge}세'),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const Text('향후 대운:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...analysis.daeunPeriods.take(5).map<Widget>((period) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${period.startAge}세: ${period.ganJi}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }

  String _getLuckyElementDescription(bool isStrong) {
    if (isStrong) {
      return '신강한 사주는 식상/재성/관성이 용신입니다.\n이 오행이 들어오는 날이 길합니다.';
    } else {
      return '신약한 사주는 인성/비겁이 용신입니다.\n이 오행이 들어오는 날이 길합니다.';
    }
  }
}
